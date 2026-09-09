@RTK.md

## 작업 착수

jj 를 쓰는 프로젝트에서 코드 작업을 시작하기 전에 `jj-work` 스킬을 로드한다. 절차는 그 안에 다 있다.

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

## Atlassian (Jira · Confluence) — MCP 대신 REST API

Jira·Confluence 작업은 `mcp__atlassian__*` 대신 **REST API** 를 쓴다. MCP 서버가 응답 없이
300초 타임아웃으로 죽어 코멘트가 유실된 이력이 있다(2026-09-09).

- 자격 증명은 환경변수에 있다: `JIRA_EMAIL`·`JIRA_API_TOKEN`(basic auth 쌍),
  `ATLASSIAN_BASIC`(선인코딩 — `Authorization: Basic $ATLASSIAN_BASIC`). **값을 출력·기록하지 않는다.**
- **`curl` 은 Bash 도구에서 context-mode 훅이 가로챈다** — `ctx_execute(language:"shell")` 안에서
  실행하고 python 으로 파싱해 필요한 값만 출력한다.
- 쓰기 실패 시 **반드시 조회로 반영 여부를 확인한 뒤** 재시도한다(중복 코멘트 방지).

```bash
B=https://soomgo.atlassian.net
curl -s -u "$JIRA_EMAIL:$JIRA_API_TOKEN" -H 'Accept: application/json' "$B/rest/api/3/myself"
```

| 용도 | 엔드포인트 |
|---|---|
| 이슈 조회 | `GET /rest/api/2/issue/<KEY>?fields=status,comment` |
| 코멘트 등록 | `POST /rest/api/2/issue/<KEY>/comment` — `{"body":"<wiki markup>"}` (v3 는 ADF) |
| 상태 전이 | `GET|POST /rest/api/2/issue/<KEY>/transitions` |
| Confluence 읽기 | `GET /wiki/api/v2/pages/<id>?body-format=storage` |
| Confluence 갱신 | `PUT /wiki/api/v2/pages/<id>` — `version.number` +1, `status:"current"` |
| 첨부 | `POST /rest/api/2/issue/<KEY>/attachments` · `POST /wiki/rest/api/content/<id>/child/attachment` (`X-Atlassian-Token: no-check`) |

- QACH 티켓 본문은 `fields=*all` 로 받아 `customfield_11769`(ADF)를 파싱한다.
- **REST 로 우회해도 게시물 작성 규약은 지킨다** — 남이 읽는 글은 존댓말, 벽글씨 금지(문단·목록),
  긴 한글 본문은 `humanize-korean` 으로 윤문한 뒤 올린다. 훅 검사는 MCP 호출에만 걸리므로
  이 규약은 스스로 지켜야 한다.
