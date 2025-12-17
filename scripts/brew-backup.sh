#!/bin/bash

#=============================================================================
# Homebrew 패키지 백업 스크립트
# 현재 설치된 brew 패키지들을 Brewfile로 내보내기
#=============================================================================

BREWFILE_PATH="$HOME/dotfiles/Brewfile"
BACKUP_DIR="$HOME/dotfiles/backups"

# 백업 디렉토리 생성
[ -d "$BACKUP_DIR" ] || mkdir -p "$BACKUP_DIR"

# 기존 Brewfile 백업 (날짜 포함)
if [ -f "$BREWFILE_PATH" ]; then
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  cp "$BREWFILE_PATH" "$BACKUP_DIR/Brewfile.$TIMESTAMP"
  echo "📦 기존 Brewfile 백업: $BACKUP_DIR/Brewfile.$TIMESTAMP"
fi

# 새 Brewfile 생성
brew bundle dump --file="$BREWFILE_PATH" --force --describe

echo ""
echo "✅ Brewfile 백업 완료: $BREWFILE_PATH"
echo ""
echo "📋 설치된 패키지 요약:"
echo "   - Taps:  $(grep -c "^tap" "$BREWFILE_PATH" 2>/dev/null || echo 0)"
echo "   - Brews: $(grep -c "^brew" "$BREWFILE_PATH" 2>/dev/null || echo 0)"
echo "   - Casks: $(grep -c "^cask" "$BREWFILE_PATH" 2>/dev/null || echo 0)"
echo "   - Apps:  $(grep -c "^mas" "$BREWFILE_PATH" 2>/dev/null || echo 0)"
