cd %userprofile%

mkdir backup_dotfiles
mkdir backup_dotfiles\nvim
move .vimrc backup_dotfiles\.vimrc
move .zshrc backup_dotfiles\.zshrc
move .bashrc backup_dotfiles\.bashrc
move .tmux.conf backup_dotfiles\.tmux.conf
move .gitconfig backup_dotfiles\.gitconfig
move .gitignore_global backup_dotfiles\.gitignore_global

move %userprofile%\AppData\Local\nvim backup_dotfiles\

mklink  %userprofile%\.vimrc %userprofile%\dotfiles\.vimrc 
mklink  %userprofile%\.zshrc %userprofile%\dotfiles\.zshrc 
mklink  %userprofile%\.bashrc %userprofile%\dotfiles\.bashrc 
mklink  %userprofile%\.tmux.conf %userprofile%\dotfiles\.tmux.conf 
mklink  %userprofile%\.gitconfig %userprofile%\dotfiles\.gitconfig 
mklink  %userprofile%\.gitignore_global %userprofile%\dotfiles\.gitignore_global 
:: mkdir %userprofile%\AppData\Local\nvim
mklink /D %userprofile%\AppData\Local\nvim %userprofile%\dotfiles\nvim
:: mklink %userprofile%\AppData\Local\nvim\coc-settings.json %userprofile%\dotfiles\nvim\coc-settings.json
