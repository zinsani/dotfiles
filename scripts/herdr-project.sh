#!/usr/bin/env bash
#=============================================================================
# herdr-project.sh — jj workspace 하나를 herdr workspace 로 띄운다.
#
#   herdr-project.sh <경로|이름> [--no-agent] [--no-editor]
#
#   herdr-project.sh next-epic          # ~/workspace/soomgo/next-epic
#   herdr-project.sh ~/some/other/repo  # 절대/상대 경로도 가능
#
# 레이아웃:
#   workspace <디렉토리명>
#   ├─ tab code   nvim │ claude      (세로 분할, 좌 60%)
#   ├─ tab run                       (dev server / test)
#   └─ tab vcs                       (jj / lazygit)
#
# workspace 이름을 디렉토리명과 1:1 로 맞추는 게 핵심이다. next-develop /
# next-epic / next-qa-patch 처럼 형제 디렉토리가 비슷해서, 사이드바 라벨이
# 곧 "지금 어느 작업 트리인가"의 유일한 표시가 된다.
#=============================================================================
set -euo pipefail

PROJECTS_ROOT="${HERDR_PROJECTS_ROOT:-$HOME/workspace/soomgo}"
EDITOR_CMD="${HERDR_EDITOR_CMD:-nvim .}"
SPLIT_RATIO=0.6

start_agent=1
start_editor=1
target=""

for arg in "$@"; do
  case "$arg" in
    --no-agent)  start_agent=0 ;;
    --no-editor) start_editor=0 ;;
    -h|--help)   sed -n '2,18p' "$0" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*)          echo "알 수 없는 옵션: $arg" >&2; exit 2 ;;
    *)           target="$arg" ;;
  esac
done

[ -n "$target" ] || { echo "사용법: $(basename "$0") <경로|이름> [--no-agent] [--no-editor]" >&2; exit 2; }

# 경로 해석: 실재하는 경로 우선, 아니면 PROJECTS_ROOT 아래에서 찾는다
if [ -d "$target" ]; then
  cwd=$(cd "$target" && pwd)
elif [ -d "$PROJECTS_ROOT/$target" ]; then
  cwd="$PROJECTS_ROOT/$target"
else
  echo "디렉토리를 찾을 수 없다: $target (또는 $PROJECTS_ROOT/$target)" >&2
  exit 1
fi

label=$(basename "$cwd")

herdr status server >/dev/null 2>&1 || {
  echo "herdr 서버에 연결할 수 없다. 먼저 herdr 를 실행할 것." >&2
  exit 1
}

# 같은 라벨의 workspace 가 이미 있으면 새로 만들지 않고 포커스만 옮긴다
existing=$(herdr workspace list \
  | jq -r --arg l "$label" '.result.workspaces[] | select(.label == $l) | .workspace_id' \
  | head -1)
if [ -n "$existing" ]; then
  herdr workspace focus "$existing" >/dev/null
  echo "이미 존재하는 workspace 로 이동: $label ($existing)"
  exit 0
fi

created=$(herdr workspace create --cwd "$cwd" --label "$label" --no-focus)
ws=$(echo "$created" | jq -r '.result.workspace.workspace_id')
code_tab=$(echo "$created" | jq -r '.result.tab.tab_id')
left=$(echo "$created" | jq -r '.result.root_pane.pane_id')

herdr tab rename "$code_tab" code >/dev/null

right=$(herdr pane split "$left" --direction right --ratio "$SPLIT_RATIO" --no-focus \
  | jq -r '.result.pane.pane_id')

for t in run vcs; do
  herdr tab create --workspace "$ws" --cwd "$cwd" --label "$t" --no-focus >/dev/null
done

[ "$start_editor" -eq 1 ] && herdr pane run "$left" "$EDITOR_CMD" >/dev/null

if [ "$start_agent" -eq 1 ]; then
  # 에이전트 이름 규칙: [a-z][a-z0-9_-]{0,31}, 살아있는 에이전트 간 유일해야 한다
  # printf 를 쓴다. echo 는 개행을 흘려 tr -c 가 그걸 '-' 로 바꿔 꼬리 하이픈이 붙는다.
  name=$(printf '%s' "$label" | tr '[:upper:]' '[:lower:]' | tr -c 'a-z0-9_-' '-' \
    | sed -e 's/^[^a-z]*//' -e 's/[-_]*$//' | cut -c1-32)
  [ -n "$name" ] || name="agent"
  if herdr agent list | jq -e --arg n "$name" '.result.agents[] | select(.name == $n)' >/dev/null 2>&1; then
    name="${name}-$$"
    name=$(echo "$name" | cut -c1-32)
  fi
  # agent start 는 pane 이 대화형 셸 프롬프트에 있어야 성공한다. 분할 직후엔
  # 아직 셸이 준비 중일 수 있어 herdr 자체 타임아웃(기본 30s)을 넉넉히 준다.
  if herdr agent start "$name" --kind claude --pane "$right" --timeout 60000 >/dev/null; then
    echo "claude 기동: $name ($right)"
  else
    echo "claude 기동 실패 — $right 에서 직접 실행할 것" >&2
  fi
fi

herdr workspace focus "$ws" >/dev/null
echo "workspace 준비 완료: $label ($ws) — code/run/vcs"
