local setmetatable = setmetatable
local assert = assert
local table = table

local Package = {min=0, max=-1}
setfenv(1,Package)

function Package:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o.idSet={}
  o.inUse={}
  for id = o.max, o.min, -1 do
    table.insert(o.idSet, id)
  end
  return o
end

function Package:pop()
  assert(#self.idSet>0, 'out of ids')
  local id = table.remove(self.idSet)
  self.inUse[id] = true
  return id
end

function Package:push(id)
  assert(self.inUse[id]==true, 'id not in use')
  table.insert(self.idSet, id)
  self.inUse[id] = false
end

return Package
