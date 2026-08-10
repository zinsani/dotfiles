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
    },
  },
}
