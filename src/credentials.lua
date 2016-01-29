local file = file
local string = string
local assert = assert
local setmetatable = setmetatable

local Package = {prefix='.', suffix='.data'}
setfenv(1,Package)

function Package:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  if not o.filename then
    assert(o.name ~= nil, 'name must be provided for credentials file')
    o.filename = o.prefix .. o.name .. o.suffix
  end
  return o
end

function Package:load()
  if (file.open(self.filename,"r")) then
    local data = file.read()
    file.close()
    local name, value = string.match(data, "([^\n]*)\n([^\n]*)")
    return name, value
  end
end

function Package:save(name, value)
  local data = (name or "") .. "\n" .. (value or "")
  file.remove(self.filename)
  file.open(self.filename,"w+")
  file.write(data)
  file.flush()
  file.close()
end

return Package
