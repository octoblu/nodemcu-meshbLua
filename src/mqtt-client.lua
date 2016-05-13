-- local clearRequireCache = require('clear-require-cache')
local setmetatable = setmetatable
local require = require
local Timer = Timer
local cjson = cjson
local pcall = pcall
local bind = bind
local node = node
local mqtt = mqtt
local log = log

local Package = {
  host = 'mqtt.cactuscon.dev',
  port = 1883,
  secure = 0,
  autoreconnect = 1,
  qos = 0,
  clientid = 'nodemcu-'..node.chipid(),
  keepalive = 120,
  uuid = nil,
  token = nil,
  cleansession = 0,

  connected = false,
  callbackId = 0,
  messageCallbacks = {},
  onTypeCallbacks = {},
  emitCallbacks = {},
  client = nil,
}
setfenv(1,Package)

function Package:new(o)
  log.debug('mqtt-client')
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Package:setCreds(uuid, token)
  self.uuid = uuid
  self.token = token
end

function Package:connect(callback)
  self.onConnected = callback
  log.debug('connecting mqtt', self.host, self.port, self.secure)
  if self.client ~= nil then
    self.client:close()
  end
  self.client = mqtt.Client(self.clientid, self.keepalive, self.uuid, self.token, self.cleansession)
  self.client:on('offline', require('bind')(_offline, self))
  self.client:on('message', require('bind')(_messageHandler, self))

  Timer:new({callback=function()
    require('clear-require-cache')()
    self.client:connect(self.host, self.port, self.secure, self.autoreconnect, require('bind')(_connected, self), require('bind')(_connectFail, self))
  end}):alarm(250)
end

function Package:close()
  return self.client.close()
end

function Package.encodeData(data)
  local valid, result = pcall(cjson.encode,data)
  return (valid and result) or cjson.encode(result)
end

function Package.decodeData(data)
  return pcall(cjson.decode,data)
end

function Package:mqttPublish(topic, data, callback)
  self.client:publish(topic,encodeData(data),self.qos,0,callback)
end

function Package:mqttSubscribe(topics, options)
  -- @client.subscribe topics, options
end

 -- API Functions
function Package:message(data, callback)
  self:_makeJob('SendMessage', nil, data, callback)
end

function Package:createSessionToken(uuid, data, callback)
  self:_makeJob('CreateSessionToken', {toUuid=uuid}, data, callback)
end

function Package:register(data, callback)
  self:_makeJob('RegisterDevice', nil, data, callback)
end

function Package:unregister(uuid, callback)
  self:_makeJob('UnregisterDevice', {toUuid=uuid}, nil, callback)
end

function Package:searchDevices(uuid, data, callback)
  self:_makeJob('SearchDevices', {fromUuid=uuid}, data, callback)
end

function Package:status(callback)
  self:_makeJob('GetStatus', nil, nil, callback)
end

function Package:subscribe(uuid, data, callback)
  self:_makeJob('CreateSubscription', {toUuid=uuid}, data, callback)
end

function Package:unsubscribe(uuid, data, callback)
  self:_makeJob('DeleteSubscription', {toUuid=uuid}, data, callback)
end

function Package:update(uuid, data, callback)
  self:_makeJob('UpdateDevice', {toUuid=uuid}, data, callback)
end

function Package:whoami(callback)
  self:_makeJob('GetDevice', {toUuid=self.uuid}, nil, callback)
end

function Package:connectFirehose(auth, callback)
  if not self.uuid then return end
  local callbackId = self:_registerCallback(callback)
  auth = auth or {uuid=self.uuid, token=self.token}
  self:mqttPublish('meshblu/firehose', {auth=auth, callbackId=callbackId, connect=true})
end

-- Private Functions
function Package:_offline(con, topic, message)
  log.error('mqtt offline!')
  log.error('restarting')
  Timer:new({callback=node.restart}):alarm(1000)
end

function Package:_connected(conn)
  log.debug('mqtt connected', self.clientid)
  -- client:subscribe(uuid, qos, function(conn)
  --   log.debug("subscribed to uuid")
  --   mqttTimer = sendPing()
  -- end)
  if self.onConnected then
    self.onConnected()
  end
end

function Package:_connectFail(conn, failure)
  log.error('failed mqtt connect', failure)
  if self.onConnected and self.autoreconnect ~= 1 then
    self.onConnected(failure)
  end
end

function Package:_registerCallback(callback)
  self.callbackId = self.callbackId + 1
  self.messageCallbacks[self.callbackId] = callback;
  return self.callbackId
end

function Package:_makeJob(jobType, metadata, data, callback)
  log.debug('_makeJob', jobType)
  metadata = metadata or {}
  metadata.jobType = jobType
  local callbackId = self:_registerCallback(callback)

  local rawData = nil
  if data ~= nil then
    rawData = encodeData(data)
  end
  log.debug(rawData)
  request = {job={metadata=metadata, rawData=rawData}, callbackId=callbackId}
  self:mqttPublish('meshblu/request', request)

  --
  -- throw new Error 'No Active Connection' unless @client?
  -- @mqttPublish 'meshblu.request', request
end

function Package:_messageHandler(conn, topic, message)
  log.debug('_messageHandler: ', topic)
  log.debug('unparsed', message)
  local valid, message = decodeData(message)
  -- log.debug('parsed',valid,message)
  if not valid then
    return
  end
  if self:_handleCallbackResponse(message) then return end
  self:emit(message.type, message.data)
end

function Package:_handleCallbackResponse(message)
  log.debug('_handleCallbackResponse')
  local id = message.callbackId
  if not id then
    return false
  end

  local callback = self.messageCallbacks[id]
  self.messageCallbacks[id] = nil
  if not callback then return false end

  if message.type == 'meshblu/error' then
    callback(message.data)
  else
    local valid, response = decodeData(message.data)
    if not valid then response = message.data end
    callback(nil, response)
  end
  return true
end

function Package:on(type, callback)
  self.onTypeCallbacks[type] = callback
end

function Package:emit(type, data)
  local callback = self.onTypeCallbacks[type]
  log.debug(type,callback)
  if not callback then return end
  callback(nil, data)
end

-- function Package:_emit()
-- _proxy(event)
--   @client.on event, =>
--     debug 'proxy ' + event, _.first arguments
--     @emit event, arguments...

return Package
