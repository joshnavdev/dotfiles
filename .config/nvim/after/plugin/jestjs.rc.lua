local status, jestjs = pcall(require, "jestjs")
if not status then return end

jestjs.setup()
