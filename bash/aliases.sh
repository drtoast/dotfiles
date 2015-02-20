case `uname` in
  Linux)
    alias ls='ls --color=auto'
    ;;
esac
alias ll='ls -al'

# Git
alias gb='git branch'
alias gba='git branch -a'
alias gd='git diff'

# Ruby/Rails
alias be='bundle exec'
alias ber='bundle exec rake'
alias rc='pry -r ./config/environment'
alias killspec='killall -9 rspec phantomjs webkit_server'

# Pow
alias pow-restart='touch ~/.pow/restart.txt'
alias pow-status='launchctl list | grep cx.pow.powd; curl -H host:pow localhost/status.json; echo'