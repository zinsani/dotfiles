local status, commentary = pcall(require, "vim_commentary")
if (not status) then return end

commentary.setup {}
