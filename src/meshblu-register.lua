local net = net
local print = print
local cjson = cjson
local assert = assert
local setmetatable = setmetatable
local meshbluCredentials = require('meshblu-credentials')

local Package = {
  meshbluHost = 'meshblu.octoblu.com',
  discoverWhitelist = {'*'},
  configureWhitelist = {'*'},
  receiveWhitelist = {'*'},
  sendWhitelist = {'*'},
  whitelist = nil,
  owner = nil
}

MeshbluRegister = Package
setfenv(1,Package)

function Package:new(o)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Package:getRequest()

  local whitelist = self.whitelist or
      '"discoverWhitelist":'..cjson.encode(self.discoverWhitelist)..','
    ..'"configureWhitelist":'..cjson.encode(self.configureWhitelist)..','
    ..'"receiveWhitelist":'..cjson.encode(self.receiveWhitelist)..','
    ..'"sendWhitelist":'..cjson.encode(self.sendWhitelist)

  local registerPayload = '{'..whitelist
    .. ((self.owner and ',"owner":"'..self.owner..'"') or '')
    ..'}'

  local registerRequest = "POST /devices HTTP/1.1\r\n"
    .."Host: "..self.meshbluHost.."\r\n"
    .."User-Agent: esp-lua/1.0\r\n"
    .."Accept: application/json\r\n"
    .."Content-Type: application/json\r\n"
    .."Content-Length: "..#registerPayload.."\r\n"
    .."\r\n"
    ..registerPayload

  return registerRequest
end

function Package:getCredentials( callback )
  assert(callback ~= nil, 'callback must be defined')

  local uuid, token = meshbluCredentials:load()
  if (uuid ~= nil and token ~= nil) then
    print("ALREADY REGISTERED WITH MESHBLU")
    return callback(uuid,token)
  end

  print("SELF REGISTERING WITH MESHBLU")

  local conn = net.createConnection(net.TCP, 0)

  conn:on( "receive", function(conn, payload)
    conn:close()
    print("RECEIVED MESHBLU DATA")
    local json = cjson.decode(payload:match("[^\r\n]+$"))
    local uuid = (json['uuid'])
    local token = (json['token'])
    meshbluCredentials:save(uuid,token)
    return callback(uuid,token)
  end )

  conn:on( "connection", function(conn)
    print("CONNECTED TO MESHBLU")
    conn:send(self:getRequest())
  end )

  conn:connect(80, self.meshbluHost)
end

return Package
