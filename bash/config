export CLICOLOR=1
export TERM=xterm-color

NOCOLOR="\[\033[0m\]"
WHITE_BOLD="\[\033[1;37m\]"
CYAN_BOLD="\[\033[1;36m\]"
RED_BOLD="\[\033[1;31m\]"
YELLOW_BOLD="\[\033[1;33m\]"
GREEN_BOLD="\[\033[1;32m\]"
BLUE_BOLD="\[\033[0;34m\]"

BLUE="\[\033[0;34m\]"
GRAY="\[\033[0;37m\]"
RED="\[\033[0;31m\]"
YELLOW="\[\033[0;33m\]"
GREEN="\[\033[0;32m\]"

function parse_git_dirty {
  [[ $(git status 2> /dev/null | tail -n1) != "nothing to commit, working directory clean" ]] && echo "⚡"
}

function parse_git_branch {
  git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e "s/* \(.*\)/\[\1$(parse_git_dirty)\]/"
}

export PS1="$RED_BOLD\$(date +'%H:%M')$NOCOLOR @$CYAN_BOLD\h $GREEN_BOLD\W $GREEN\$(parse_git_branch)$NOCOLOR\$ "

#export LSCOLORS=gxfxcxdxbxegedabagacad
export LS_COLORS="di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=0;41:sg=0;46:tw=0;42:ow=0;43:"
