return function(data)
  if not data then return end
  if data.type ~= 'command' then return end

  log.debug('executing a remote function')

  local function send(uuid, type, messageId, data)
    local message = {
      devices = {uuid},
      type = type,
      messageId = messageId,
      payload = data,
    }
    log.debug('have response: ', data)
    log.debug('of type', type)
    log.debug('sending to', uuid)
    mqttClient:message(message)
  end

  local script = data.payload
  local fromUuid = data.fromUuid
  local messageId = data.messageId
  local context = {
    Timer = Timer,
    node = node,
    file = require('file-safe'),
    print = function(msg)
      send(fromUuid, 'print', messageId, msg)
    end
  }
  require('clear-require-cache')()
  local _, result = require('function').execute(context, script)
  send(fromUuid, 'return', messageId, result)
end
