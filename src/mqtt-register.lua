return function(callback)
  log.debug('mqtt-register')

  require('async-waterfall')(
    function(error,data)
      if error then return callback(error) end
      require('mqtt-credentials'):save(data.uuid,data.token)
      log.error('restarting with credentials')
      callback('restart-creds')
    end, {
      'bind-mqtt-register',
      'bind-mqtt-connect',
  })
end
