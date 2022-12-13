local status, fugitive = pcall(require, "fugitive")
if (not status) then return end

fugitive.setup{}


