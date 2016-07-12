cd ~

[-d backup_dotfiles] || mkdir backup_dotfiles
mv -f ~/.vimrc ~/backup_dotfiles/.vimrc
mv -f ~/.bashrc ~/backup_dotfiles/.bashrc
mv -f ~/.tmux.conf ~/backup_dotfiles/.tmux.conf

ln -s ~/dotfiles/.vimrc ~/.vimrc
ln -s ~/dotfiles/.bashrc ~/.bashrc
ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
