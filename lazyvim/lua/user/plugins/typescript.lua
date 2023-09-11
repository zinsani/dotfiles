local status, typescript = pcall(require, "typescript-vim")
if (not status) then return end

typescript.setup{}

