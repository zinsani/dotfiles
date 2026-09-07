#!/bin/bash
set -e

#=============================================================================
# kanata 용 Karabiner 드라이버 복구
#=============================================================================
#
# 증상: kanata 는 떠 있는데 키가 하나도 리맵되지 않고, 로그에
#       "connect_failed asio.system:2" 가 무한히 찍힌다.
#
# 원인: Karabiner-Elements 16.1.0+ 는 VirtualHIDDevice 드라이버 v8.x 를 깔고
#       자동 업데이트로 조용히 올라간다. kanata 는 v6.2.0 의 IPC 만 안다.
#       드라이버 v7 에서 전송 방식이 datagram -> Unix domain stream 으로
#       바뀌어서 프로토콜이 서로 호환되지 않는다.
#
# 처방: Karabiner-Elements 를 지우고 standalone 드라이버 v6.2.0 만 남긴다.
#       kanata 는 드라이버만 있으면 되고, KE 앱은 자동 업데이터까지 끌고 와서
#       같은 사고를 반복시킨다.
#
# 주의: jtroo/kanata#2123 (2026-07-28 머지) 가 v8 을 지원한다. 이게 릴리스에
#       포함되면 이 스크립트는 필요 없어지고, 그때는 kanata 와 드라이버를
#       "같이" v8 로 올려야 한다. 한쪽만 올리면 다시 깨진다.
#
# 이 스크립트는 여러 번 실행해도 안전하다. 드라이버 승인은 GUI 를 거쳐야 해서
# 중간에 한 번 멈추는데, 승인 후 다시 실행하면 이어서 진행한다.
#
# 사용법: sudo ~/dotfiles/scripts/kanata-driver-fix.sh
#=============================================================================

DRIVER_VERSION="6.2.0"
PKG_URL="https://github.com/pqrs-org/Karabiner-DriverKit-VirtualHIDDevice/releases/download/v${DRIVER_VERSION}/Karabiner-DriverKit-VirtualHIDDevice-${DRIVER_VERSION}.pkg"
PKG="/tmp/Karabiner-DriverKit-VirtualHIDDevice-${DRIVER_VERSION}.pkg"
DK="/Library/Application Support/org.pqrs/Karabiner-DriverKit-VirtualHIDDevice"
DAEMON_PLIST="$DK/Applications/Karabiner-VirtualHIDDevice-Daemon.app/Contents/Info.plist"
MANAGER="/Applications/.Karabiner-VirtualHIDDevice-Manager.app/Contents/MacOS/Karabiner-VirtualHIDDevice-Manager"

if [ "$(id -u)" -ne 0 ]; then
  echo "❌ sudo 로 실행하세요: sudo $0"
  exit 1
fi

# 설치된 드라이버 버전. 없으면 빈 문자열.
installed_version() {
  [ -f "$DAEMON_PLIST" ] || return 0
  defaults read "$DAEMON_PLIST" CFBundleVersion 2>/dev/null || true
}

#=============================================================================
# 0. 현재 상태 확인
#=============================================================================

CURRENT="$(installed_version)"
echo "현재 드라이버: ${CURRENT:-없음}"

# 이미 목표 버전이고 승인까지 끝났으면 할 일이 없다.
if [ "$CURRENT" = "$DRIVER_VERSION" ]; then
  if systemextensionsctl list 2>/dev/null | grep -q "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice.*activated enabled"; then
    echo "✅ 드라이버 v${DRIVER_VERSION} 가 이미 활성화돼 있습니다. 할 일이 없습니다."
    echo "   키가 여전히 안 먹으면 kanata 쪽 문제입니다: kanata-start 후 /tmp/kanata.log 확인"
    exit 0
  fi
  # 설치는 됐는데 승인 대기 중 -> 활성화 단계로 건너뛴다.
  echo "ℹ️  v${DRIVER_VERSION} 설치됨, 승인 대기 상태입니다. 활성화만 다시 시도합니다."
  SKIP_INSTALL=1
fi

#=============================================================================
# 1. 패키지 내려받기 + 서명 검증
#=============================================================================

if [ -z "${SKIP_INSTALL:-}" ]; then
  if [ ! -f "$PKG" ]; then
    echo "==> 드라이버 v${DRIVER_VERSION} 내려받는 중"
    curl -fsSL -o "$PKG" "$PKG_URL"
  fi

  # 키보드 입력을 가로채는 커널 확장이다. 서명은 반드시 확인한다.
  echo "==> 서명 검증"
  if ! pkgutil --check-signature "$PKG" | grep -q "Fumihiko Takayama (G43BCU2T37)"; then
    echo "❌ 서명이 pqrs-org 의 것이 아닙니다. 중단합니다."
    rm -f "$PKG"
    exit 1
  fi

  #===========================================================================
  # 2. 기존 kanata / Karabiner-Elements 정리
  #===========================================================================

  echo "==> kanata 중지"
  pkill -f '/opt/homebrew/bin/kanata' 2>/dev/null || true

  # KE 언인스톨러가 드라이버 파일까지 같이 지운다. 드라이버만 따로 깔 것이므로
  # 확장을 먼저 비활성화한 뒤 지워야 찌꺼기가 안 남는다.
  if [ -f "$DK/scripts/uninstall/deactivate_driver.sh" ]; then
    echo "==> 기존 드라이버 확장 비활성화 (v${CURRENT:-?})"
    bash "$DK/scripts/uninstall/deactivate_driver.sh" || true
  fi

  if [ -f "/Library/Application Support/org.pqrs/Karabiner-Elements/uninstall.sh" ]; then
    echo "==> Karabiner-Elements 제거"
    bash "/Library/Application Support/org.pqrs/Karabiner-Elements/uninstall.sh" || true
  fi
  rm -rf /Applications/Karabiner-Elements.app /Applications/Karabiner-EventViewer.app

  #===========================================================================
  # 3. v6.2.0 설치
  #===========================================================================

  echo "==> 드라이버 v${DRIVER_VERSION} 설치"
  installer -pkg "$PKG" -target /

  NEW="$(installed_version)"
  if [ "$NEW" != "$DRIVER_VERSION" ]; then
    echo "❌ 설치 후 버전이 v${DRIVER_VERSION} 가 아닙니다 (v${NEW:-없음}). 중단합니다."
    exit 1
  fi
fi

#=============================================================================
# 4. 활성화 (사용자 승인 필요)
#=============================================================================

echo "==> 드라이버 활성화 요청"
"$MANAGER" activate || true

# systemextensionsctl 에 반영될 때까지 잠깐 기다린다.
sleep 3

if systemextensionsctl list 2>/dev/null | grep -q "org.pqrs.Karabiner-DriverKit-VirtualHIDDevice.*activated enabled"; then
  echo ""
  echo "✅ 드라이버 v${DRIVER_VERSION} 활성화 완료"
  echo "   이제 kanata-start 로 띄우고 /tmp/kanata.log 에 'entering the event loop' 가"
  echo "   찍히는지 확인하세요. connect_failed 가 계속되면 재부팅 후 다시 시도합니다."
else
  echo ""
  echo "⚠️  드라이버가 승인 대기 상태입니다. macOS 가 GUI 승인을 요구합니다."
  echo ""
  echo "    시스템 설정 > 일반 > 로그인 항목 및 확장 프로그램 > 드라이버 확장 프로그램"
  echo "    에서 Karabiner-DriverKit-VirtualHIDDevice 를 켜세요."
  echo ""
  echo "    승인 후 이 스크립트를 한 번 더 실행하면 이어서 확인합니다."
  echo ""
  open "x-apple.systempreferences:com.apple.LoginItems-Settings.extension" 2>/dev/null || true
  exit 2
fi

#=============================================================================
# 5. 입력 모니터링 권한 안내
#=============================================================================

echo ""
echo "ℹ️  키가 여전히 안 먹으면 시스템 설정 > 개인정보 보호 및 보안 > 입력 모니터링 에서"
echo "   /opt/homebrew/bin/kanata 가 허용돼 있는지 확인하세요."
