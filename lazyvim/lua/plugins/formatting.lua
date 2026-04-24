-- Formatting: prettier (conform) + eslint auto-fix
--
-- 문제: LazyVim의 eslint: lsp 포매터가 conform.format({lsp_format="fallback"})을 호출하면
-- prettier(CLI 포매터)가 있으면 eslint LSP를 건너뜀 → eslint auto-fix 미작동
--
-- 해결: nvim-lspconfig format.lsp_format = "first" → eslint LSP 먼저 실행 후 prettier 실행
return {
  -- 1. eslint auto-fix: lsp_format="first"로 eslint LSP → prettier 순서 보장
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- LazyVim.lsp.format()이 이 설정을 참조함:
      -- eslint: lsp 포매터 호출 시 eslint LSP가 먼저 auto-fix 적용 후 prettier 실행
      format = {
        lsp_format = "first",
      },
    },
  },

  -- 2. conform.nvim: prettier 포매터 안정성 강화
  {
    "stevearc/conform.nvim",
    opts = {
      -- 포매터 실패 시 알림 표시 (문법 에러로 prettier가 실패할 때 명시적으로 표시)
      notify_on_error = true,
      -- log_level = vim.log.levels.DEBUG, -- 진단 필요 시 주석 해제
    },
    init = function()
      -- LazyVim format chain의 백업: BufWritePre에서 conform 직접 호출
      -- LazyVim의 LazyFormat autocmd에 문제가 생겨도 prettier는 항상 실행됨
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = vim.api.nvim_create_augroup("ConformFormatOnSave", { clear = true }),
        callback = function(args)
          local gaf = vim.g.autoformat
          local baf = vim.b[args.buf].autoformat
          local enabled = baf ~= nil and baf or (gaf == nil or gaf)
          if not enabled then
            return
          end
          if vim.bo[args.buf].buftype ~= "" then
            return
          end
          require("conform").format({ bufnr = args.buf, timeout_ms = 3000 })
        end,
      })
    end,
  },
}
