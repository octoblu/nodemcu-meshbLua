return function(callback)
  log.debug('wifi-check')
  wifi.setmode(wifi.STATION)
  wifi.setphymode(wifi.PHYMODE_N)
  wifi.sleeptype(wifi.MODEM_SLEEP)

  -- local function setupWifiMonitor()
  Timer:new({callback=function(timer)
    local ip = wifi.sta.getip()
    if ip then
      timer:unregister()
      log.debug('got ip', ip)
      return callback()
    end
  end}):alarm(500, Timer.REPEAT)
  -- end

  -- local wifiCredentials = require('wifi-credentials')
  -- local networkConf, passwordConf = wifi.sta.getconfig()
  -- local networkFile, passwordFile = wifiCredentials:load()
  -- local requiresConfig = (
  --   networkConf == nil or #networkConf == 0 or
  --   networkConf ~= networkFile or passwordConf ~= passwordFile
  -- )
  --
  -- log.debug('connecting', networkFile)
  --
  -- if not requiresConfig then
  --   return setupWifiMonitor()
  -- end
  --
  -- if networkFile and #networkFile > 0 then
  --   wifi.sta.config(networkFile, passwordFile)
  --   return setupWifiMonitor()
  -- end
  --
  -- log.error('wifi start-smart?')
  -- wifi.startsmart(0, function(network, password)
  --   wifiCredentials:save(network,password)
  --   log.debug('restarting...')
  --   Timer:new({callback=node.restart}):alarm(1000)
  -- end)
end
