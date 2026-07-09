@echo off
setlocal

set DOTFILES=%userprofile%\dotfiles
set BACKUP=%userprofile%\backup_dotfiles

:: Install scoop (Windows package manager)
where scoop >nul 2>nul || (
    powershell -Command "Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force; irm get.scoop.sh | iex"
)

:: Install packages via scoop
for %%p in (git neovim fzf ripgrep fd lazygit) do (
    where %%p >nul 2>nul || scoop install %%p
)

:: Backup existing dotfiles (skip symlinks)
if not exist "%BACKUP%" mkdir "%BACKUP%"
for %%f in (.vimrc .zshrc .bashrc .tmux.conf .gitconfig .gitignore_global) do (
    if exist "%userprofile%\%%f" move /Y "%userprofile%\%%f" "%BACKUP%\%%f"
)

:: Backup nvim config
if exist "%localappdata%\nvim" move /Y "%localappdata%\nvim" "%BACKUP%\nvim.bak"
if exist "%localappdata%\nvim-data" move /Y "%localappdata%\nvim-data" "%BACKUP%\nvim-data.bak"

:: Create symlinks for dotfiles
for %%f in (.vimrc .zshrc .bashrc .tmux.conf .gitconfig .gitignore_global) do (
    if not exist "%userprofile%\%%f" mklink "%userprofile%\%%f" "%DOTFILES%\%%f"
)

:: Install LazyVim
if not exist "%DOTFILES%\lazyvim" (
    git clone https://github.com/LazyVim/starter "%DOTFILES%\lazyvim"
)

:: Link nvim config
if not exist "%localappdata%\nvim" mklink /D "%localappdata%\nvim" "%DOTFILES%\lazyvim"

:: Remove .git folder from lazyvim
if exist "%DOTFILES%\lazyvim\.git" rmdir /S /Q "%DOTFILES%\lazyvim\.git"

echo Bootstrap complete!
echo.
echo Next steps:
echo   1. Restart terminal or 'source ~/.zshrc'
echo   2. Open Neovim to auto-install plugins
echo   3. In Tmux, press prefix + I to install plugins

endlocal
