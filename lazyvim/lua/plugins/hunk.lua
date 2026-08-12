-- hunk 는 두 가지가 있다:
--  1) hunk.nvim  — jj/git 의 diff-editor (jj split, jj diffedit 에서 열림)
--  2) hunk CLI   — 터미널 diff 뷰어 (https://hunk.dev), jj 의 pager 로도 사용 중
return {
  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    config = function()
      require("hunk").setup()
    end,
  },

  -- hunk CLI 를 float 터미널로 띄우는 키맵 (jj/git 저장소 자동 감지)
  --
  -- 키 자리: <leader>gd/gD. 원래 <leader>gh 였는데 LazyVim 의 gitsigns hunk
  -- 프리픽스(ghd/ghs/ghr/ghb/ghp...)와 겹쳐, 단독 gh 를 누르면 nvim 이 더 긴
  -- 매핑을 기다리느라 timeoutlen(기본 1s)만큼 지연됐다. gd/gD 는 difftastic 이
  -- 쓰던 자리인데 jj diff 를 hunk 으로 옮긴 뒤 잔재로만 남아 있어 함께 제거했다.
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gd",
        function()
          Snacks.terminal({ "hunk", "diff" }, { cwd = LazyVim.root(), interactive = true })
        end,
        desc = "Hunk: diff (working copy)",
      },
      {
        "<leader>gD",
        function()
          Snacks.terminal({ "hunk", "show" }, { cwd = LazyVim.root(), interactive = true })
        end,
        desc = "Hunk: show (last commit)",
      },
      -- 현재 파일만. hunk CLI 는 `hunk diff [target] [-- <pathspec...>]` 를 받는다.
      -- 경로는 레포 루트 기준 상대경로여야 pathspec 으로 먹는다.
      {
        "<leader>gF",
        function()
          local root = LazyVim.root()
          local file = vim.fn.expand("%:p")
          if file == "" then
            vim.notify("현재 버퍼에 파일이 없다", vim.log.levels.WARN)
            return
          end
          local rel = vim.fs.relpath(root, file) or file
          Snacks.terminal({ "hunk", "diff", "--", rel }, { cwd = root, interactive = true })
        end,
        desc = "Hunk: diff current file",
      },
    },
  },
}
