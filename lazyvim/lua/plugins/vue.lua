-- Vue 2.7 LSP (hybrid mode, @vue/language-server 3.0.11 고정)
--
-- 왜 3.0.11 인가
--   Vue 2 지원은 3.1.0 (2025-09-28) 의 "refactor: drop Vue 2 support (#5636)" 에서
--   제거됐다. 즉 3.0.x 가 Vue 2.7 의 상한선이다.
--   (흔히 알려진 "Volar 2.0 에서 끊겼다" 는 틀린 정보다.)
--
-- 왜 Mason 이 아니라 별도 디렉토리인가
--   Mason 은 @vue/language-server 와 @vue/typescript-plugin 의 버전을 함께
--   고정해주지 못한다. 실제로 language-server 3.0.11 을 설치해도 플러그인은
--   3.3.9 가 딸려와 Vue 2 처리가 깨졌다. :MasonUpdate 한 번이면 조용히 되돌아간다.
--   그래서 ~/.local/share/vue-ls-3.0 에 둘을 같은 버전으로 못박고 여기를 가리킨다.
--   재설치: cd ~/.local/share/vue-ls-3.0 && npm install
--
-- takeover mode 는 3.0.0 에서 제거됐다. 이제 hybrid mode 만 있다.
--   - vue_ls  : .vue 파일의 template/style 담당
--   - vtsls   : TS 담당. @vue/typescript-plugin 을 통해 .vue 의 script 를 이해한다
--   - 둘 사이 통신은 nvim-lspconfig 의 vue_ls 기본 설정에 들어있는
--     `tsserver/request` 포워딩 핸들러가 처리한다 (직접 작성 불필요)
--
-- 프로젝트 쪽 요구사항: tsconfig.json 에 vueCompilerOptions.target = 2.7
--   (vue-develop 에는 이미 설정돼 있다)
--
-- 이 파일은 프로젝트를 가리지 않는다. hybrid mode 에서 vue_ls 는 .vue 파일에만
-- 붙으므로, React 레포에서는 아무 일도 일어나지 않는다.

local vue_ls_root = vim.fn.expand("~/.local/share/vue-ls-3.0/node_modules")
local vue_ls_bin = vue_ls_root .. "/.bin/vue-language-server"
local vue_plugin_path = vue_ls_root .. "/@vue/typescript-plugin"

-- 고정 설치가 없으면 조용히 물러난다 (다른 머신에서 clone 했을 때)
if vim.fn.executable(vue_ls_bin) == 0 then
  vim.schedule(function()
    vim.notify(
      "vue-ls-3.0 이 없다. `cd ~/.local/share/vue-ls-3.0 && npm install` 로 설치할 것.",
      vim.log.levels.WARN
    )
  end)
  return {}
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      -- vue_ls: 고정 설치 바이너리를 쓴다. cmd 외 나머지(filetypes, root_markers,
      -- tsserver/request 핸들러)는 nvim-lspconfig 기본값을 그대로 쓴다.
      opts.servers.vue_ls = vim.tbl_deep_extend("force", opts.servers.vue_ls or {}, {
        cmd = { vue_ls_bin, "--stdio" },
      })

      -- LazyVim 의 vue extra 가 이미 @vue/typescript-plugin 을 vtsls globalPlugins 에
      -- 넣지만 location 이 Mason 경로다. 항목을 추가하지 말고 경로만 고쳐 끼운다
      -- (추가하면 플러그인이 두 번 로드된다).
      local plugins = vim.tbl_get(opts.servers, "vtsls", "settings", "vtsls", "tsserver", "globalPlugins")
      if plugins then
        for _, plugin in ipairs(plugins) do
          if plugin.name == "@vue/typescript-plugin" then
            plugin.location = vue_plugin_path
          end
        end
      end
    end,
  },
}
