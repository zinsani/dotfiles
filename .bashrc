ANDROID_HOME=/usr/local/opt/android-sdk
export PATH=$ANDROID_HOME/tools:$ANDROID_HOME/platform-tools:/usr/local/mysql/bin:$PATH
export EDITOR=vim
export TERM="xterm-256color"
alias vi=/Applications/MacVim.app/Contents/MacOS/Vim

###-tns-completion-start-###
if [ -f /Users/jsp/.tnsrc ]; then 
    source /Users/jsp/.tnsrc 
fi
###-tns-completion-end-###

###-tns-completion-start-###
if [ -f /Users/parkjinsan/.tnsrc ]; then 
    source /Users/parkjinsan/.tnsrc 
fi
###-tns-completion-end-###
