source ~/.bash/aliases.sh
source ~/.bash/completions.sh
source ~/.bash/paths.sh
source ~/.bash/config.sh
source ~/.bash/environment.sh

# rvm
if [ -s ~/.rvm/scripts/rvm ] ; then source ~/.rvm/scripts/rvm ; fi

# specific to this host (git ignored)
if [ -s ~/.bash/local.sh ] ; then source ~/.bash/local.sh ; fi
