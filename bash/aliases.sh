case `uname` in
  Linux)
    alias ls='ls --color=auto'
    ;;
esac
alias ll='ls -al'

# Git
alias gds='git diff --staged'
alias gs='git status -sbu'
alias git-delete-merged='git branch --merged | egrep -v "(^\*|master)" | xargs git branch -d'
