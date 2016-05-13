return function(callback)
  log.debug('mqtt-auth')

  local auth = require('mqtt-credentials')
  local uuid, token = auth:load()

  if uuid and token then
    log.debug(uuid)
    mqttClient.uuid = uuid
    mqttClient.token = token
    return callback()
  end

  local device = {
    configureWhitelist = {'*'},
    discoverWhitelist = {'*'},
    receiveWhitelist = {'*'},
    sendWhitelist = {'*'},
    nodemcu = {
      chipid = node.chipid(),
      flashid = node.flashid(),
      mac = wifi.sta.getmac(),
    },
  }

  require('async-waterfall')(
    function(error,data)
      if error then return callback(error) end
      auth:save(data.uuid,data.token)
      log.error('restarting with credentials')
      callback('restart')
    end, {
      require('bind')(mqttClient.register, mqttClient, device),
      require('bind')(mqttClient.connect, mqttClient),
  }, 500)

end
