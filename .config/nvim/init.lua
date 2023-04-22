require "base"
require "highlights"
require "globals"

if IS_MAC == 1 then
  require "macos"
end

if IS_WIN == 1 then
  require "windows"
end

if IS_LIN == 1 then
  require "linux"
end

require "maps"
require "plugins"
