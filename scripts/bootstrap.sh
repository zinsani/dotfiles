cd ~

[ -d backup_dotfiles ] || mkdir backup_dotfiles
mv -f ~/.vimrc ~/backup_dotfiles/.vimrc
mv -f ~/.zshrc ~/backup_dotfiles/.zshrc
mv -f ~/.bashrc ~/backup_dotfiles/.bashrc
mv -f ~/.tmux.conf ~/backup_dotfiles/.tmux.conf
mv -f ~/.gitconfig ~/backup_dotfiles/.gitconfig
mv -f ~/.gitignore_global ~/backup_dotfiles/.gitignore_global

ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global
mkdir ~/.config
cp -r ~/dotfiles/nvim ~/.config

