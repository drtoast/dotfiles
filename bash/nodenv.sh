export PATH="/Users/jamesreynolds/.nodenv/shims:${PATH}"
export NODENV_SHELL=bash
source '/usr/local/Cellar/nodenv/1.1.2/libexec/../completions/nodenv.bash'
command nodenv rehash 2>/dev/null
nodenv() {
  local command
  command="$1"
  if [ "$#" -gt 0 ]; then
    shift
  fi

  case "$command" in
  rehash|shell)
    eval "$(nodenv "sh-$command" "$@")";;
  *)
    command nodenv "$command" "$@";;
  esac
}
