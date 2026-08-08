-- ~/.config/yazi/init.lua
-- bookmarks.yazi: 기본값(persist="none")은 재시작 시 초기화되므로 명시적으로 켬
-- https://github.com/dedukun/bookmarks.yazi
require("bookmarks"):setup({
	persist = "all",
})
