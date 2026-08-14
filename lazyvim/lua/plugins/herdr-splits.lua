-- nvim 스플릿 ↔ herdr pane 을 같은 키로 이동/리사이즈한다.
-- smart-splits.nvim 을 herdr CLI 로 포팅한 것. vim-tmux-navigator 를 대체한다.
--
-- 동작:
--   C-h/j/k/l 을 herdr 이 먼저 가로챈다 → 포커스된 pane 이 nvim 이면 키를 그 안으로
--   전달하고, nvim 은 가장자리에 닿았을 때만 herdr 로 되넘긴다. nvim 이 아닌 pane
--   (셸·claude)에서는 herdr 이 바로 pane 을 옮긴다. tmux 의 if-shell 조건부 전달을
--   herdr 쪽 plugin_action 이 대신하는 구조.
--
-- 짝이 되는 herdr 쪽 설정:
--   plugin: herdr plugin install lmilojevicc/herdr-splits.nvim
--   keymap: ~/.config/herdr/config.toml 의 [[keys.command]] ctrl+hjkl / alt+hjkl
--
-- 전제: Ghostty 의 macos-option-as-alt = true (M- 키가 Alt 로 전달되어야 함)
return {
  {
    "lmilojevicc/herdr-splits.nvim",
    cond = vim.env.HERDR_ENV == "1", -- herdr 밖에서는 로드하지 않는다
    event = "VeryLazy",
    -- 이 플러그인은 키맵을 스스로 만들지 않는다. setup() 의 nav_keys/resize_keys 는
    -- herdr 쪽 conf 를 생성하기 위한 선언일 뿐이므로, nvim 매핑은 여기서 직접 건다.
    keys = {
      { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Go to left window/pane" },
      { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Go to lower window/pane" },
      { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Go to upper window/pane" },
      { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Go to right window/pane" },
      { "<M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize left" },
      { "<M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize down" },
      { "<M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize up" },
      { "<M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize right" },
    },
    opts = {
      default_amount = 0.03, -- herdr pane 리사이즈 비율
      neovim_amount = 3, -- nvim 창 리사이즈 셀 수
      at_edge = "wrap",
      -- LazyVim 이 쓰는 사이드바/플로트에서 키가 갇히지 않게 한다
      ignored_filetypes = {
        "neo-tree",
        "snacks_dashboard",
        "snacks_explorer",
        "snacks_picker",
        "aerial",
        "Outline",
        "Trouble",
        "quickfix",
        "dadbod-ui",
        "dbout",
      },
    },
  },
}
