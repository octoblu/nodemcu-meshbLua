return function(callback)
  mqttClient:on('meshblu/message', function(error, data)
    log.error('got some command data!')
    require('remote-execute')(data)
  end)
  callback()
end
