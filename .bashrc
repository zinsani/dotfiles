ANDROID_HOME=/usr/local/opt/android-sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:$PATH
export PATH="/usr/local/opt/sqlite/bin:$PATH"
export PATH="/usr/local/mysql/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/opt/X11/bin:/usr/local/git/bin:$PATH"
export PATH="./node_modules/.bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

export TERM="xterm-256color"
alias vim=/usr/local/Cellar/vim/8.2.2650/bin/vim
alias vi=vim
export EDITOR=vim
# alias vi=/Applications/MacVim.app/Contents/MacOS/Vim

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
# nvm alias default 4.5.0
# nvm use 4.5.0

###-tns-completion-start-###
# if [ -f $HOME/.tnsrc ]; then 
#     source $HOME/.tnsrc 
# fi
###-tns-completion-end-###


###-tns-completion-start-###
# if [ -f /Users/parkjinsan/.tnsrc ]; then 
#     source /Users/parkjinsan/.tnsrc 
# fi
###-tns-completion-end-###
