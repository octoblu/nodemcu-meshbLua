local Timer = require('timer-auto')
local node = node
local print = print
local tostring = tostring

local Package = {}
TestTimerAuto = Package
setfenv(1,Package)

local secret = 1337

function doIt()

  local startTime = Timer.now()
  local delay = 1000
  tmr = Timer:new({callback=function(t)
    print("in cb of tmr1")
    delay = delay + 250
    local timeDiff = Timer.now()-startTime
    print("timeDiff1: "..tostring(timeDiff))
    if timeDiff<(5*1000*1000) then
      t:alarm(delay)
    end
  end}):alarm(delay)

  Timer:new({callback=function(t)
    print("in cb of tmr2 with id: "..tostring(t.id))
    local timeDiff = Timer.now()-startTime
    print("timeDiff2: "..tostring(timeDiff))
    if timeDiff>(500*1000) then
      t:stop()
    end
  end}):alarm(100,1)

  local count = 0
  Timer:new({callback=function(t)
    print("in cb of tmr3 with id: "..tostring(t.id))
    count = count+1
    if count==3 then
      t:stop()
    end
  end}):alarm(1,1)

  Timer:new({callback=function(t)
    print("in cb of tmr4")
  end}):alarm()
end

local function getSecret()
  return secret
end

hello = getSecret

return Package
