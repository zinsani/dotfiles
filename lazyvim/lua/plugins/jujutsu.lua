return {
  "yannvanhalewyn/jujutsu.nvim",
  config = function()
    require("jujutsu-nvim").setup({
      -- 내장 프리셋(difftastic/diffview/codediff) 대신 <CR>에서 hunk를 직접 실행
      diff_preset = "none",
      keymap = {
        ["<CR>"] = {
          cmd = function()
            local jjnvim = require("jujutsu-nvim")
            local jj = require("jujutsu-nvim.jujutsu")
            local ids = vim.tbl_keys(jjnvim.state.selected_changes)
            if #ids == 0 then
              jjnvim.with_change_at_cursor(function(change_id)
                ids = { change_id }
              end)
            end
            if #ids == 0 then
              return
            end
            vim.cmd("tabnew")
            vim.fn.jobstart({ "hunk", "diff", jj.make_revset(ids) }, { term = true })
            vim.cmd("startinsert")
          end,
          desc = "Open diff (hunk)",
        },
      },
    })
  end,
}
