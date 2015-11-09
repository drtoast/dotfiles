#!/usr/bin/env ruby

require 'fileutils'
require 'optparse'
require 'digest'

def hash_for(file)
  Digest::MD5.file(file).hexdigest
end

module ToastUtils
  class Renamer
    def initialize(options)
      @dir = options[:dir]
      @add = options[:add]
      @remove = options[:remove]
      @dry_run = options[:dry_run]
    end

    def rename
      process_dir(@dir)
    end

    private

    def process_dir(dir)
      Dir.entries(dir).each do |file|
        original = File.join(dir, file)
        next if file.match /^\./
        if File.directory? original
          process_dir original
          next
        elsif File.file? original
          new_path = new_path_for file, dir
          puts new_path
          unless @dry_run
            FileUtils.mv(original, new_path) unless original == new_path
          end
        end
      end
    end

    def new_path_for(file, dir)
      file.prepend "#{@add} " if @add
      file.sub!(/^#{@remove}\s+/, '') if @remove
      File.join(dir, file)
    end
  end

  class DuplicatesDetector
    def initialize(options)
      @files = {}
      @dir = options[:dir]
    end

    def detect
      process_dir(@dir)
    end

    def results
      @files.each do |hash, files|
        if files.length > 1
          puts ""
          puts hash
          files.each do |f|
            puts f
          end
        end
      end
    end

    private

    def process_dir(dir)
      Dir.entries(dir).each do |entry|
        file = File.join(dir, entry)
        next if entry.match /^\./
        if File.directory? file
          puts file
          process_dir file
          next
        elsif File.file? file
          hash = hash_for file
          @files[hash] ||= []
          @files[hash] << file
        end
      end
    end
  end

  class DirectoryComparator
    def initialize(options)
      @quiet = options[:quiet]
      @dir_a = options[:dir_a]
      @dir_b = options[:dir_b]
      @hashes = {}
    end

    def compare
      process_dir(@dir_a, :a)
      process_dir(@dir_b, :b)
    end

    def results
      puts "Processed #{@hashes.keys.length} files"

      results = @hashes.select do |k,v|
        v.keys.include?(:a) && v.keys.include?(:b)
      end
      puts "In A and B: #{results.keys.length} files"
      unless @quiet
        results.each do |k,v|
          puts v[:a]
        end
        puts ""
      end

      results = @hashes.select do |k,v|
        !v.keys.include?(:b)
      end
      puts "Only in A: #{results.keys.length} files"

      unless @quiet
        results.each do |k,v|
          puts v[:a]
        end
        puts ""
      end

      results = @hashes.select do |k,v|
        !v.keys.include?(:a)
      end
      puts "Only in B: #{results.keys.length} files"

      unless @quiet
        results.each do |k,v|
          puts v[:b]
        end
        puts ""
      end
    end

    private

    def process_dir(dir, group)
      Dir.entries(dir).each do |entry|
        file = File.join(dir, entry)
        next if entry.match /^\./
        if File.directory? file
          puts file unless @quiet
          process_dir file, group
          next
        elsif File.file? file
          hash = hash_for file
          @hashes[hash] ||= {}
          @hashes[hash][group] = file
        end
      end
    end
  end
end

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: toastutils.rb [options]"

  opts.on("--rename", "Rename files") do
    options[:command] = :rename

    opts.on("-a", "--add TEXT", "Prepend text to filenames") do |text|
      options[:add] = text
    end

    opts.on("-r", "--remove TEXT", "Remove leading text from filenames") do |text|
      options[:remove] = text
    end

    opts.on("-d", "--directory DIR", "Set target directory") do |dir|
      options[:dir] = dir
    end
  end

  opts.on("--duplicates", "Detect duplicate files") do
    options[:command] = :duplicates
    opts.on("-d", "--directory DIR", "Set target directory") do |dir|
      options[:dir] = dir
    end
  end

  opts.on("--compare", "Compare two directories") do
    options[:command] = :compare
    opts.on("-a", "--directory-a DIR_A", "Set directory A") do |dir_a|
      options[:dir_a] = dir_a
    end

    opts.on("-b", "--directory-b DIR_B", "Set directory B") do |dir_b|
      options[:dir_b] = dir_b
    end
  end

  opts.on("-q", "--quiet", "Quiet output") do
    options[:quiet] = true
  end

  opts.on("--dry-run", "Don't change files") do
    options[:dry_run] = true
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end
end.parse!

case options[:command]
when :duplicates
  detector = ToastUtils::DuplicatesDetector.new(options)
  detector.detect
  detector.results
when :compare
  comparator = ToastUtils::DirectoryComparator.new(options)
  comparator.compare
  comparator.results
when :rename
  renamer = ToastUtils::Renamer.new(options)
  renamer.rename
end

