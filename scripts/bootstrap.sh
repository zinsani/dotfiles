#!/bin/bash
set -e

cd ~

#=============================================================================
# macOS 시스템 설정
#=============================================================================

# 키 반복 입력 활성화 (길게 누르면 특수문자 선택 대신 반복 입력)
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# 키 반복 속도 설정 (낮을수록 빠름, 기본값: 6)
defaults write NSGlobalDomain KeyRepeat -int 2

# 키 반복 시작 딜레이 (낮을수록 빠름, 기본값: 25)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Finder: 숨김 파일 표시
defaults write com.apple.finder AppleShowAllFiles -bool true

# Finder: 파일 확장자 항상 표시
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 스크린샷 저장 위치 변경
[ -d ~/Screenshots ] || mkdir ~/Screenshots
defaults write com.apple.screencapture location ~/Screenshots

#=============================================================================
# 패키지 매니저 설치
#=============================================================================

# Oh My Zsh 설치
[ -d ~/.oh-my-zsh ] || sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Homebrew 설치
[ "$(command -v brew)" ] || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Homebrew PATH 설정 (중복 방지)
if ! grep -q 'brew shellenv' ~/.zprofile 2>/dev/null; then
  echo >> ~/.zprofile
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
fi
eval "$(/opt/homebrew/bin/brew shellenv)"

# Brewfile로 패키지 일괄 설치
brew bundle install --file="$HOME/dotfiles/Brewfile"

#=============================================================================
# 기존 설정 백업
#=============================================================================

[ -d ~/backup_dotfiles ] || mkdir ~/backup_dotfiles

# dotfiles 백업
[ -e ~/.vimrc ] && mv -f ~/.vimrc ~/backup_dotfiles/
[ -e ~/.zshrc ] && mv -f ~/.zshrc ~/backup_dotfiles/
[ -e ~/.bashrc ] && mv -f ~/.bashrc ~/backup_dotfiles/
[ -e ~/.tmux.conf ] && mv -f ~/.tmux.conf ~/backup_dotfiles/
[ -e ~/.gitconfig ] && mv -f ~/.gitconfig ~/backup_dotfiles/
[ -e ~/.gitignore_global ] && mv -f ~/.gitignore_global ~/backup_dotfiles/

# Neovim 관련 디렉토리 백업
[ -d ~/.config/nvim ] && mv -f ~/.config/nvim ~/backup_dotfiles/
[ -d ~/.local/share/nvim ] && mv -f ~/.local/share/nvim ~/backup_dotfiles/nvim-share.bak
[ -d ~/.local/state/nvim ] && mv -f ~/.local/state/nvim ~/backup_dotfiles/nvim-state.bak
[ -d ~/.cache/nvim ] && mv -f ~/.cache/nvim ~/backup_dotfiles/nvim-cache.bak

#=============================================================================
# 디렉토리 생성
#=============================================================================

[ -d ~/.config ] || mkdir -p ~/.config
[ -d ~/.local/share ] || mkdir -p ~/.local/share
[ -d ~/.local/state ] || mkdir -p ~/.local/state

#=============================================================================
# Symlink 생성
#=============================================================================

[ -L ~/.vimrc ] || ln -s ~/dotfiles/.vimrc ~/.vimrc
[ -L ~/.zshrc ] || ln -s ~/dotfiles/.zshrc ~/.zshrc
[ -L ~/.bashrc ] || ln -s ~/dotfiles/.bashrc ~/.bashrc
[ -L ~/.tmux.conf ] || ln -s ~/dotfiles/.tmux.conf ~/.tmux.conf
[ -L ~/.gitconfig ] || ln -s ~/dotfiles/.gitconfig ~/.gitconfig
[ -L ~/.gitignore_global ] || ln -s ~/dotfiles/.gitignore_global ~/.gitignore_global

#=============================================================================
# Neovim (LazyVim) 설정
#=============================================================================

# LazyVim starter 클론
[ -d ~/dotfiles/lazyvim ] || git clone https://github.com/LazyVim/starter ~/dotfiles/lazyvim

# nvim config 심볼릭 링크
[ -L ~/.config/nvim ] || ln -s ~/dotfiles/lazyvim ~/.config/nvim

# .git 폴더 제거 (개인 dotfiles repo와 충돌 방지)
[ -d ~/dotfiles/lazyvim/.git ] && rm -rf ~/dotfiles/lazyvim/.git

#=============================================================================
# Tmux 설정
#=============================================================================

# TPM (Tmux Plugin Manager) 설치
[ -d ~/.tmux/plugins/tpm ] || git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#=============================================================================
# 완료
#=============================================================================

# 변경된 Finder 설정 적용
killall Finder 2>/dev/null || true

echo "✅ Bootstrap 완료!"
echo ""
echo "📌 추가 작업:"
echo "   1. 터미널 재시작 또는 'source ~/.zshrc' 실행"
echo "   2. Neovim 실행하여 플러그인 자동 설치 확인"
echo "   3. Tmux에서 prefix + I 로 플러그인 설치"
