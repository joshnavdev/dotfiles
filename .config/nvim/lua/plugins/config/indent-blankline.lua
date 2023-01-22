local status, blankline = pcall(require, "indent=blankline")
if (not status) then return end

print('setting blankline')
blankline.setup()
