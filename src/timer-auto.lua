local TimerId = require('timer-id')
local setmetatable = setmetatable
local unpack = unpack
local assert = assert
local type = type
local tmr = tmr

local Package = {}
setfenv(1,Package)

Package.new = function(self, o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

local pushId = function(self)
  if self.id == nil then return end
  TimerId:push(self.id)
  self.id = nil
end

local popId = function(self)
  if self.id ~= nil then return end
  self.id = TimerId:pop()
end

Package.hasId = function(self)
  return self.id ~= nil
end

local function proxyAlarmRegister(func)
  return function(self, interval, mode)
    interval = interval or 1
    mode = mode or SINGLE
    popId(self)
    return func(self.id, interval, mode, function()
      if mode == SINGLE then
        pushId(self)
      end
      self.callback(self)
    end)
  end
end

Package.alarm = proxyAlarmRegister(tmr.alarm)
Package.register = proxyAlarmRegister(tmr.register)

local function proxyId(func)
  return function(self, ...)
    if not self or not self.id then return end
    return func(self.id, unpack(arg))
  end
end

local proxyUnregister = proxyId(tmr.unregister)
Package.unregister = function(self)
  proxyUnregister(self)
  pushId(self)
end

Package.interval = proxyId(tmr.interval)
Package.stop     = proxyId(tmr.stop)
Package.start    = proxyId(tmr.start)
Package.state    = proxyId(tmr.state)

Package.delay    = tmr.delay
Package.now      = tmr.now
Package.time     = tmr.time
Package.softwd   = tmr.softwd
Package.wdclr    = tmr.wdclr
Package.SINGLE   = tmr.ALARM_SINGLE
Package.SEMI     = tmr.ALARM_SEMI
Package.REPEAT   = tmr.ALARM_AUTO

return Package
