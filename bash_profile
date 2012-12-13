source ~/.bash/aliases
source ~/.bash/completions
source ~/.bash/paths
source ~/.bash/config
source ~/.bash/environment

# rvm
if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi
    
# specific to this host (git ignored)
if [ -s ~/.bash/local ] ; then source ~/.bash/local ; fi

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"
