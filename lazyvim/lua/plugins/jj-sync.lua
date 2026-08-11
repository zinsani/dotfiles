-- jj 커밋을 옮겨다닐 때 LSP 를 손으로 재시작하지 않아도 되게 한다.
--
-- 문제의 원인 두 가지
--
-- 1) 버퍼가 낡은 채로 남는다.
--    LazyVim 의 checktime autocmd 는 FocusGained / TermClose / TermLeave 에서만
--    돈다. jj 를 herdr 의 다른 pane 에서 실행하면 nvim 은 포커스를 잃지도
--    얻지도 않으므로 checktime 이 영영 안 돈다. 그래서 디스크는 바뀌었는데
--    버퍼는 옛 내용이고, LSP 는 그 옛 내용을 정답으로 알고 있다.
--
-- 2) 열려 있지 않은 파일의 변경을 tsserver 가 놓친다.
--    macOS 의 nvim 0.11 은 libuv fs_event(FSEvents)로 didChangeWatchedFiles 를
--    보내지만, jj checkout 처럼 수백 개가 한꺼번에 바뀌면 취약하다.
--    이때는 tsserver 를 다시 띄우는 게 가장 확실하다.
--
-- 해법: jj 의 working copy 포인터를 감시해서, 바뀌면 버퍼 리로드 + TS 서버 재시작.
--   .jj/working_copy/checkout 은 커밋을 옮길 때마다 갱신된다.
--
-- 수동 실행: :JJSync

local M = {}

local TS_SERVERS = { vtsls = true, ts_ls = true, vue_ls = true, eslint = true }

function M.sync(opts)
  opts = opts or {}

  -- 1. 디스크에서 바뀐 버퍼를 다시 읽는다
  vim.cmd("checktime")

  -- 2. TS 계열 서버만 재시작한다 (lua_ls 등 무관한 서버까지 흔들 이유가 없다)
  local restarted = {}
  for _, client in ipairs(vim.lsp.get_clients()) do
    if TS_SERVERS[client.name] then
      table.insert(restarted, client.name)
    end
  end

  if #restarted > 0 then
    vim.cmd("LspRestart " .. table.concat(restarted, " "))
  end

  if not opts.silent then
    vim.notify(
      #restarted > 0 and ("jj sync: " .. table.concat(restarted, ", ") .. " 재시작") or "jj sync: 버퍼만 리로드",
      vim.log.levels.INFO
    )
  end
end

-- .jj/working_copy/checkout 감시
local function watch_jj(root)
  local target = root .. "/.jj/working_copy/checkout"
  if vim.fn.filereadable(target) == 0 then
    return
  end

  local handle = vim.uv.new_fs_event()
  if not handle then
    return
  end

  local pending = false
  handle:start(target, {}, function()
    -- jj 가 파일을 여러 번 건드리므로 디바운스한다
    if pending then
      return
    end
    pending = true
    vim.defer_fn(function()
      pending = false
      M.sync({ silent = false })
      -- fs_event 는 rename/replace 후 감시가 끊기므로 다시 건다
      pcall(function()
        handle:stop()
        handle:start(target, {}, function() end)
      end)
    end, 300)
  end)

  vim.api.nvim_create_autocmd("VimLeavePre", {
    callback = function()
      pcall(function()
        handle:stop()
      end)
    end,
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    init = function()
      vim.api.nvim_create_user_command("JJSync", function()
        M.sync()
      end, { desc = "jj: 버퍼 리로드 + TS 서버 재시작" })

      vim.keymap.set("n", "<leader>cJ", function()
        M.sync()
      end, { desc = "jj sync (reload + restart TS)" })

      -- 디스크가 바뀌면 자동으로 버퍼를 다시 읽게 한다
      vim.o.autoread = true

      -- LazyVim 기본(FocusGained/TermClose/TermLeave)에 더해, herdr pane 을
      -- 오가는 동안에도 낡은 버퍼를 잡도록 트리거를 넓힌다
      vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold" }, {
        group = vim.api.nvim_create_augroup("jj_checktime", { clear = true }),
        callback = function()
          if vim.o.buftype == "" then
            vim.cmd("checktime")
          end
        end,
      })

      -- jj 레포면 working copy 포인터를 감시한다
      local root = vim.fs.root(0, { ".jj" })
      if root then
        watch_jj(root)
      end
    end,
  },
}
