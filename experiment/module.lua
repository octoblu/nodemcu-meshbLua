local print        = print
local tostring     = tostring
local setmetatable = setmetatable

local Package = {}
setfenv(1,Package)

function Package:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Package:tests()
  print("verify: "..tostring(self:verify()))
end

function Package:verify()
  return self.data==1
end

return Package
