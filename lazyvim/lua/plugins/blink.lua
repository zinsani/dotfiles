-- LazyVim 기본 보완 엔진이 blink.cmp 다. (coding.nvim-cmp extra 를 빼면 자동으로 켜진다)
-- 여기서는 기본값 위에 얹는 조정만 한다.
return {
  {
    "saghen/blink.cmp",
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- 함수 인자 힌트를 입력 중에 띄운다
      signature = { enabled = true },

      completion = {
        documentation = { auto_show_delay_ms = 100 },
        -- 첫 항목을 미리 선택해 두어 nvim-cmp 때와 같은 <CR> 감각을 유지
        list = { selection = { preselect = true, auto_insert = false } },
      },

      -- preset "enter": <CR> 수락, <C-n>/<C-p> 이동, <C-space> 메뉴/문서,
      -- <C-e> 닫기, <Tab> 은 스니펫 점프 → AI 수락 → fallback 순서
      keymap = { preset = "enter" },
    },
  },
}
