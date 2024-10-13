export LC_ALL=ko_KR.UTF-8

export TERM="xterm-256color"
# alias vim=/usr/local/Cellar/vim/8.2.2650/bin/vim
# alias vi=vim
# alias vi=/Applications/MacVim.app/Contents/MacOS/Vim
alias oldvim="vim"
alias vim="nvim"
export EDITOR="nvim"
export USE_EDITOR=$EDITOR
export VISUAL=$EDITOR

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh" # This loads nvm

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
