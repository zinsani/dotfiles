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
      -- 현재 파일만. hunk CLI 는 `hunk diff|show [target] [-- <pathspec...>]` 를 받는다.
      -- 경로는 레포 루트 기준 상대경로여야 pathspec 으로 먹는다.
      --
      -- gF 는 "작업 사본의 미커밋 변경"만 본다. 커밋 이력이 있어도 지금 수정한 게
      -- 없으면 비어 있는 게 정상인데, hunk 은 그걸 "No files match the current
      -- filter" 로만 알려줘서 오해하기 쉽다. 그래서 먼저 변경 여부를 확인하고
      -- 비어 있으면 무엇을 눌러야 하는지 알려준다.
      {
        "<leader>gF",
        function()
          require("util.hunk").file_diff()
        end,
        desc = "Hunk: diff current file (working copy)",
      },
      -- 현재 파일을 마지막으로 건드린 커밋의 diff
      {
        "<leader>gH",
        function()
          require("util.hunk").file_last_commit()
        end,
        desc = "Hunk: current file's last commit",
      },
    },
  },
}
