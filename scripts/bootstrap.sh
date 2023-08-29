cd ~

[ "$(command -v brew)" ] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
[ "$(command -v git)"] || brew install git
[ "$(command -v nvm)"] || brew install nvm
[ "$(command -v neovim)"] || brew install neovim
[ "$(command -v fzf)"] || brew install fzf
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

[ -d backup_dotfiles ] || mkdir backup_dotfiles
[ -e ~/.vimrc ] && mv -f ~/.vimrc ~/backup_dotfiles/.vimrc
[ -e ~/.zshrc ] && mv -f ~/.zshrc ~/backup_dotfiles/.zshrc
[ -e ~/.bashrc ] && mv -f ~/.bashrc ~/backup_dotfiles/.bashrc
[ -e ~/.tmx.conf ] && mv -f ~/.tmux.conf ~/backup_dotfiles/.tmux.conf
[ -e ~/.gitconfig ] && mv -f ~/.gitconfig ~/backup_dotfiles/.gitconfig
[ -e ~/.gitignore_global ] && mv -f ~/.gitignore_global ~/backup_dotfiles/.gitignore_global
[ -d backup_dotfiles/nvim ] || mkdir backup_dotfiles/nvim
[ -d ~/.config/nvim ] && mv -f ~/.config/nvim ~/backup_dotfiles/nvim

## lazyvim
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
[ -d .config ] || mkdir ~/.config
ln -s ~/dotfiles/lazyvim/nvim ~/.config/nvim
