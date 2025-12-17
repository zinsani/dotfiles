@echo off
:: go to home
cd %userprofile%

:: install scoop (Windows package manager)
where scoop >nul 2>nul || (
    powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; irm get.scoop.sh | iex"
)

:: install packages via scoop
where git >nul 2>nul || scoop install git
where nvim >nul 2>nul || scoop install neovim
where fzf >nul 2>nul || scoop install fzf
where rg >nul 2>nul || scoop install ripgrep
where fd >nul 2>nul || scoop install fd
where lazygit >nul 2>nul || scoop install lazygit

:: backup prev dotfiles
if not exist backup_dotfiles mkdir backup_dotfiles
if exist .vimrc move /Y .vimrc backup_dotfiles\.vimrc
if exist .zshrc move /Y .zshrc backup_dotfiles\.zshrc
if exist .bashrc move /Y .bashrc backup_dotfiles\.bashrc
if exist .tmux.conf move /Y .tmux.conf backup_dotfiles\.tmux.conf
if exist .gitconfig move /Y .gitconfig backup_dotfiles\.gitconfig
if exist .gitignore_global move /Y .gitignore_global backup_dotfiles\.gitignore_global

:: backup nvim config
if not exist backup_dotfiles\nvim mkdir backup_dotfiles\nvim
if exist %userprofile%\AppData\Local\nvim move /Y %userprofile%\AppData\Local\nvim backup_dotfiles\

:: optional but recommended - backup nvim data
if exist %userprofile%\AppData\Local\nvim-data move /Y %userprofile%\AppData\Local\nvim-data backup_dotfiles\nvim-data.bak

:: make symlinks for dotfiles
mklink %userprofile%\.vimrc %userprofile%\dotfiles\.vimrc
mklink %userprofile%\.zshrc %userprofile%\dotfiles\.zshrc
mklink %userprofile%\.bashrc %userprofile%\dotfiles\.bashrc
mklink %userprofile%\.tmux.conf %userprofile%\dotfiles\.tmux.conf
mklink %userprofile%\.gitconfig %userprofile%\dotfiles\.gitconfig
mklink %userprofile%\.gitignore_global %userprofile%\dotfiles\.gitignore_global

:: install lazyvim
if not exist %userprofile%\dotfiles\lazyvim (
    git clone https://github.com/LazyVim/starter %userprofile%\dotfiles\lazyvim
)

:: link nvim config
mklink /D %userprofile%\AppData\Local\nvim %userprofile%\dotfiles\lazyvim

:: remove .git folder from lazyvim
if exist %userprofile%\AppData\Local\nvim\.git rmdir /S /Q %userprofile%\AppData\Local\nvim\.git

:: Install tmux/tpm (if running in WSL or similar)
:: git clone https://github.com/tmux-plugins/tpm %userprofile%\.tmux\plugins\tpm
