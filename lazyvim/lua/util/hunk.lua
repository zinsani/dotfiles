-- hunk CLI 를 현재 파일 범위로 띄우는 헬퍼.
--
-- 왜 별도 모듈인가: 키맵 안에 넣기엔 로직이 길고, jj/git 분기와 비동기 확인이
-- 들어간다. plugins/hunk.lua 에서 require("util.hunk") 로 쓴다.

local M = {}

---현재 버퍼의 (레포 루트, 상대경로)를 구한다. 실패하면 nil.
local function target()
  local file = vim.fn.expand("%:p")
  if file == "" or vim.bo.buftype ~= "" then
    vim.notify("현재 버퍼에 파일이 없다", vim.log.levels.WARN)
    return nil
  end

  -- LazyVim.root() 는 LSP root 를 먼저 보므로 모노레포에서 하위 패키지를
  -- 가리킬 수 있다. pathspec 은 VCS 루트 기준이어야 하므로 .jj/.git 을 직접 찾는다.
  local root = vim.fs.root(file, { ".jj", ".git" })
  if not root then
    vim.notify("jj/git 저장소가 아니다", vim.log.levels.WARN)
    return nil
  end

  return root, vim.fs.relpath(root, file) or file
end

---hunk TUI 를 풀윈도우로 띄운다.
---
---width/height = 0 은 snacks.win 규약으로 "전체"를 뜻한다 (기본값은 0.9 플로트).
---테두리를 없애 편집 화면과 같은 크기로 쓴다.
---
---종료: 터미널 모드에서는 hunk 자신이 q 를 처리하고, 빠져나온 뒤(<C-\><C-n>)에는
---snacks.win 기본 키맵인 q=close 가 받는다. hunk 프로세스가 끝나면
---interactive=true 에 딸린 auto_close 가 창을 닫는다.
local function open(args, root)
  Snacks.terminal(vim.list_extend({ "hunk" }, args), {
    cwd = root,
    interactive = true,
    win = {
      width = 0,
      height = 0,
      border = "none",
      keys = { q = "close" },
    },
  })
end

---작업 사본 전체 diff
function M.diff()
  local root = vim.fs.root(0, { ".jj", ".git" }) or LazyVim.root()
  open({ "diff" }, root)
end

---직전 커밋 전체 show
function M.show()
  local root = vim.fs.root(0, { ".jj", ".git" }) or LazyVim.root()
  open({ "show" }, root)
end

---작업 사본의 미커밋 변경을 현재 파일 범위로 연다.
function M.file_diff()
  local root, rel = target()
  if not root then
    return
  end

  local is_jj = vim.fn.isdirectory(root .. "/.jj") == 1
  local check = is_jj and { "jj", "--config=ui.paginate=never", "diff", "--stat", rel }
    or { "git", "diff", "--stat", "--", rel }

  vim.system(check, { cwd = root, text = true }, function(res)
    vim.schedule(function()
      local out = res.stdout or ""
      -- jj 는 변경이 없어도 "0 files changed ..." 를 찍고, git 은 빈 문자열이다.
      local unchanged = is_jj and out:match("^%s*0 files changed") or (not is_jj and vim.trim(out) == "")

      if unchanged then
        vim.notify(
          ("%s: 작업 사본에 변경 없음.\n커밋 이력은 <leader>gf, 마지막 커밋 diff 는 <leader>gH"):format(rel),
          vim.log.levels.INFO
        )
        return
      end

      open({ "diff", "--", rel }, root)
    end)
  end)
end

---현재 파일을 마지막으로 수정한 커밋의 diff 를 연다.
function M.file_last_commit()
  local root, rel = target()
  if not root then
    return
  end

  -- jj 레포도 colocated git 이 있으면 git log 로 리비전을 찾는 게 빠르고 정확하다.
  vim.system({ "git", "log", "-1", "--format=%H", "--", rel }, { cwd = root, text = true }, function(res)
    vim.schedule(function()
      local rev = vim.trim(res.stdout or "")
      if rev == "" then
        vim.notify(("%s: 커밋 이력이 없다"):format(rel), vim.log.levels.INFO)
        return
      end
      open({ "show", rev, "--", rel }, root)
    end)
  end)
end

return M
