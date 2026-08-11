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
  {
    "folke/snacks.nvim",
    keys = {
      {
        "<leader>gh",
        function()
          Snacks.terminal({ "hunk", "diff" }, { cwd = LazyVim.root(), interactive = true })
        end,
        desc = "Hunk: diff (working copy)",
      },
      {
        "<leader>gH",
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
