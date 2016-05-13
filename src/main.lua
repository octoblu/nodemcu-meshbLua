_G.log = require('log')
_G.Timer = require('timer-auto')

_G.mqttClient = require('mqtt-client'):new({
  host="192.168.1.87",
  port=8883,
  secure=1,
})

-- _G.file = require('file-safe')
-- _G.print = function()end

node.setcpufreq(node.CPU160MHZ)

Timer.softwd(60)
log.error('main...')
local finished = function(error)
  assert(not error)
  log.error('...fin')
  -- Timer.softwd(5*60)
  Timer.softwd(0)
end

require('async-waterfall')(finished, {
  require('mqtt-load-auth'),
  'wifi-connect'
})
