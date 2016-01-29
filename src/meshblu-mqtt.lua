
local Timer = require('timer-auto')
local Function = require('function')
local mqtt = mqtt
local node = node
local print = print
local cjson = cjson
local pcall = pcall
local tostring = tostring
local setmetatable = setmetatable

local Package = {
  host = "meshblu.octoblu.com",
  port = 1883,
  qos = 0,
  clientid = "nodemcu-"..node.chipid(),
  connected = false,
  client = nil,
}
setfenv(1,Package)

function Package:new()
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  return o
end

local function encodeData(data)
  local valid, result = pcall(cjson.encode,data)
  return (valid and result) or cjson.encode(result)
end

function Package:send(uuid,type,messageId,data)
  if (client and uuid) then
    local payload = '{'
      ..((messageId and '"messageId":'..cjson.encode(messageId)..',') or '')
      ..'"payload":'..encodeData(data)..','
      ..'"type":"'..type..'",'
      ..'"devices":["'..uuid..'"]'
      ..'}'
    -- print('send: '..payload)
    client:publish('message',payload,0,0)
    print(node.heap())
  end
end

function Package:init(uuid,token)
  print("init mqtt")
  if (client) then
      client:close()
  end

  local function connect()
    client:connect(self.host, self.port, self.qos, function(conn)
      self.connected = true
      print("Connected to MQTT:" .. self.host .. ":" .. self.port .." as " .. self.clientid )
      client:subscribe(uuid, self.qos, function(conn)
        print("subscribed to uuid")
      end)
    end)
  end

  client = mqtt.Client(clientid, 120, uuid, token)
  client:lwt("/lwt", clientid, 0, 0)

  client:on("offline", function(con, topic, message)
    print("mqtt://"..host.." offline!")
  end)

  client:on("message", function(conn, topic, data)
    if data ~= nil then
      local json = cjson.decode(data)

      if json.topic then
        if json.topic == 'message' then
          if json.data and json.data.type == 'command' then
            local script = json.data.payload
            local fromUuid = json.data.fromUuid
            local messageId = json.data.messageId
            local context = {
              Timer = Timer,
              node = node,
              print = function(msg)
                self:send(fromUuid,'print',messageId,msg)
              end
            }
            local _, result = Function.execute(context,script)
            self:send(fromUuid,'return',messageId,result)
          else
            print("missing command in message!")
          end
        else
          print("message topic is not 'message'!")
        end
      else
        print("no topic in message!")
      end
    end
  end)

  pcall(connect)
end

return Package
