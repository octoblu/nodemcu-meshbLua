local loadstring = loadstring
local setfenv = setfenv
local assert = assert
local pcall = pcall

local Package = {}
setfenv(1,Package)

local function doScript(context,script)
  local condition = loadstring(script)
  assert(condition,'invalid script syntax')
  setfenv(condition,context)
  return condition()
end

Package.execute = function(context,script)
  return pcall(doScript,context,script)
end

return Package
