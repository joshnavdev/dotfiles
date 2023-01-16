local status, indmult = pcall(require, "indentation-multiline")
if (not status) then return end

indmult.setup()
