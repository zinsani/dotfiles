@RTK.md

## 시스템 알림 (장시간 작업 완료 통지)

장시간 작업(배포/CD, 머지 사이클, 긴 빌드) 완료 시, 또는 진행 중 사용자 결정이 필요한
블로커를 만났을 때 macOS 시스템 알림을 보낸다. 몇 초짜리 작업이나 사용자가 지켜보는
대화 중에는 보내지 않는다.

```bash
terminal-notifier -title "Claude Code" -message "<행동 가능한 결과 한 줄>" -activate com.mitchellh.ghostty -sound Glass
```

- 메시지는 200자 이내, 결과/블로커를 먼저 (예: "staging CD 완료: NEXT·VUE Healthy").
- `terminal-notifier` 미설치 시 fallback:
  `osascript -e 'display notification "<메시지>" with title "Claude Code"'`
  (클릭 시 Script Editor가 열리는 한계가 있으므로 가급적 terminal-notifier 설치 권장 — Brewfile 포함)
- 메인 터미널은 Ghostty(`com.mitchellh.ghostty`). 다른 머신에서 터미널이 다르면
  `osascript -e 'id of app "<터미널명>"'`으로 bundle id 를 확인해 교체.
