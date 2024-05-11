# go to home
cd ~

# disable key hold funcionnality of osx
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# install ohmyzsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# install homebrew
[ "$(command -v brew)" ] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# set path
(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# backup prev dotfiles 
[ -d backup_dotfiles ] || mkdir backup_dotfiles
[ -e ~/.vimrc ] && mv -f ~/.vimrc ~/backup_dotfiles/.vimrc
[ -e ~/.zshrc ] && mv -f ~/.zshrc ~/backup_dotfiles/.zshrc
[ -e ~/.bashrc ] && mv -f ~/.bashrc ~/backup_dotfiles/.bashrc
[ -e ~/.tmx.conf ] && mv -f ~/.tmux.conf ~/backup_dotfiles/.tmux.conf
[ -e ~/.gitconfig ] && mv -f ~/.gitconfig ~/backup_dotfiles/.gitconfig
[ -e ~/.gitignore_global ] && mv -f ~/.gitignore_global ~/backup_dotfiles/.gitignore_global
[ -d backup_dotfiles/nvim ] || mkdir backup_dotfiles/nvim
[ -d ~/.config/nvim ] && mv -f ~/.config/nvim ~/backup_dotfiles/nvim

# install packages via homebrew
[ "$(command -v git)"] || brew install git
[ "$(command -v nvm)"] || brew install nvm
[ "$(command -v neovim)"] || brew install neovim
[ "$(command -v fzf)"] || brew install fzf

## lazyvim
# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# make symlinks for dotfiles
ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
[ -d .config ] || mkdir ~/.config

# required
mv ~/.config/nvim{,.bak}

# optional but recommended
mv ~/.local/share/nvim{,.bak}
mv ~/.local/state/nvim{,.bak}
mv ~/.cache/nvim{,.bak}

# install lazyvim
git clone https://github.com/LazyVim/starter ~/dotfiles/lazyvim

# remove .git folder 
rm -rf ~/.config/nvim/.git
ln -s ~/dotfiles/lazyvim ~/.config/nvim

# Install brew bundle
brew bundle install --file="~/dotfiles/Brewfile"
