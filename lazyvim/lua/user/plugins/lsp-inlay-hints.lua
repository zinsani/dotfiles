local status, ih = pcall(require, "inlay-hints")
if (not status) then return end

ih.setup {}
