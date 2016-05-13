setmetatable(_G, {
  __metatable = nil,
  __index = _G.__index,
  __newindex = function (t,k,v)
    error("denied", 2)
  end
})
