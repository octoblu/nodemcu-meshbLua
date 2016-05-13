local xor = require('xor')
local setmetatable = setmetatable
local require = require
local assert = assert
local string = string
local table = table
local file = file

local Package = {prefix='.', suffix='.data', key=nil}
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
    data = xor(data, self.key)
    return data:match((data:gsub("[^\n]*\n?", "([^\n]*)\n?")))
  end
end

function Package:save(...)
  local data = table.concat(arg,'\n')
  data = xor(data, self.key)
  -- file.remove(self.filename)
  file.open(self.filename,"w+")
  file.write(data)
  file.flush()
  file.close()
end

function Package:exists()
  return file.exists(self.filename)
end

return Package
