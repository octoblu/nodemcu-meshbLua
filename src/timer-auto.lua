local tmr = tmr
local assert = assert
local setmetatable = setmetatable
local TimerId = require('timer-id')

local Package = {}
setmetatable(Package, {__index = tmr})
setfenv(1,Package)

function Package:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Package:alarm(interval, multiple)
  interval = interval or 1
  multiple = multiple or 0
  if self.id == nil then
    self.id = TimerId:pop()
  end
  tmr.alarm(self.id, interval, multiple, function()
    if multiple == 0 then
      self.id = TimerId:push(self.id)
    end
    self.callback(self)
  end)
  return self
end

function Package:stop()
  if self.id ~= nil then
    tmr.stop(self.id)
    self.id = TimerId:push(self.id)
  end
end

function callback()
  assert(false,'callback not defined')
end

return Package
