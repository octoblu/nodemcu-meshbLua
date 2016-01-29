local pcall = pcall
local assert = assert
local setfenv = setfenv
local loadstring = loadstring

local Package = {}

setfenv(1,{})

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
