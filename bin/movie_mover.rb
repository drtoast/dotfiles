#!/usr/bin/ruby
require 'date'
require 'fileutils'

# find movie files and move them to a mirrored hierarchy
class MovieMover
  def initialize(originals, destination, dry_run = false)
    @originals_path = originals
    @destination_path = destination
    @dry_run = dry_run
    self
  end

  def run
    2011.upto(Time.now.year) do |year|
      year_path = File.join(@originals_path, year.to_s)
      next unless File.directory?(year_path)
      Dir.foreach(year_path) do |date|
        next if /^\./ === date
        date_path = File.join(year_path, date)
        Dir.foreach(date_path) do |file|
          next if /^\./ === file
          handle_file(date_path, file, year, date)
        end
      end
    end
  end

  private

  def handle_file(date_path, file, year, date)
    file_path = File.join(date_path, file)
    return unless File.file?(file_path)
    return unless /\.(m4v|mov|avi|mp4)/i === File.extname(file_path)
    destination_dir_path = File.join(@destination_path, year.to_s, date)
    destination_file_path = File.join(destination_dir_path, file)
    unless @dry_run
      move_file(destination_dir_path, file_path, destination_file_path)
    end
    p [file_path, destination_file_path]
  end

  def move_file(destination_dir_path, file_path, destination_file_path)
    FileUtils.mkdir_p(destination_dir_path)
    FileUtils.mv(file_path, destination_file_path)
  end
end

class PictureRenamer
  def initialize(originals)
    @originals_path = originals
    self
  end

  def run
    Dir.entries(@originals_path).each do |entry|
      next if /^\./ === entry
      begin
        formatted = Date.parse(entry).strftime("%Y-%m-%d")
        original_path = File.join(@originals_path, entry)
        destination_path = File.join(@originals_path, formatted)
        p original_path
        p destination_path
        File.rename original_path, destination_path
      rescue => e
        p "can't parse #{entry}: #{e.inspect}"
      end
    end
  end
end

# match files in "originals" with same-named files in "destination"
class PictureMatcher

  def initialize(originals, destination)
    @originals_path = originals
    @destination_path = destination
    @originals = {}
    @destination = {}
    self
  end

  def run
    process_destination(@destination_path)
    process_originals(@originals_path)
  end

  def process_destination(path)
    Dir.entries(path).each do |entry|
      next if /^\./ === entry
      full_path = File.join(path, entry)
      if File.directory? full_path
        process_destination(full_path)
      elsif /\.jpg/i === File.extname(entry)
        size = File.size(full_path)
        @destination[entry] ||= []
        @destination[entry].push({
          :path => full_path,
          :size => size
        })
      end

    end
  end

  def process_originals(path)
    Dir.entries(path).each do |entry|
      next if /^\./ === entry
      full_path = File.join path, entry
      if File.directory? full_path
        process_originals full_path
      elsif /\.jpg/i === File.extname(entry)
        if match = @destination[entry]
          size = File.size(full_path)
          p '--------------'
          p [size, full_path]
          match.each do |dest|
            p [dest[:size], dest[:path]]
          end
        end
      else
        p entry
      end
    end
  end

end

originals = '/Users/drtoast/Dropbox/Photos'
destination = '/Users/drtoast/Dropbox/Videos'
MovieMover.new(originals, destination).run
