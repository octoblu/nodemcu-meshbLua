return function(callback)
  log.debug('game-client')
  require('async-waterfall')(
    callback, {
    'report-team',
    'on-message',
    'bind-mqtt-firehose',
    'bind-mqtt-whoami',
    'bind-mqtt-connect',
  })
end
