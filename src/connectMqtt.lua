local host = "meshblu.octoblu.com"
local port = 1883
local qos = 0
local clientid = "nodemcu-"..node.chipid()
local connected = false
local client = nil

function send_mqtt(uuid,data)
  if (client and uuid) then
    local payload = '{"devices":["'..uuid..'"],"type":"result","payload":"'..tostring(data)..'"}'
    client:publish('message',payload,0,0)
  end
end

function init_mqtt(uuid,token)
    print("init mqtt")
    if (client) then
        client:close()
    end

    client = mqtt.Client(clientid, 120, uuid, token)

    client:lwt("/lwt", clientid, 0, 0)

    local function connect()
      client:connect(host, port, qos, function(conn)
        connected = true
        print("Connected to MQTT:" .. host .. ":" .. port .." as " .. clientid )
        client:subscribe(uuid, qos, function(conn)
          print("subscribed to uuid")
        end)
      end)
    end

    client:on("offline", function(con, topic, message)
        connected = false
        print ("offline, waiting 10 seconds")
        tmr.alarm(6, 10000, 0, function()
            if (not connected) then
                print ("reconnecting...")
                pcall(connect)
            end
        end)
    end)

    client:on("message", function(conn, topic, data)
      if data ~= nil then
        local json = cjson.decode(data)

        if json.topic then
            if json.topic == 'message' then
              if json.data and json.data.type == 'command' then
                local cmd = json.data.payload
                local fromUuid = json.data.fromUuid
                local script = ""
                  .."local uuid='"..fromUuid.."'\n"
                  .."local function doCommand()\n"
                  .."  "..cmd.."\n"
                  .."end\n"
                  .."local function sendResult()\n"
                  .."  send_mqtt(uuid,doCommand())\n"
                  .."end\n"
                  .."if not pcall(sendResult) then\n"
                  .."  send_mqtt(uuid,'error:failed')\n"
                  .."end\n"
                node.input(script)
              else
                print("missing command in message!")
              end
            else
              print("message topic is not 'message'! : " .. json.topic)
            end
        else
          print("no topic in message!")
        end
      end
    end)

    pcall(connect)
end
