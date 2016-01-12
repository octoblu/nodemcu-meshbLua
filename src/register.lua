require("credentials")

local registerPayload =  '{'
  -- ..'"owner":"none",'
  ..'"discoverWhitelist":["*"],'
  ..'"configureWhitelist":["*"],'
  ..'"receiveWhitelist":["*"],'
  ..'"sendWhitelist":["*"]'
  ..'}'

local meshbluHost = 'meshblu.octoblu.com'

local registerRequest = "POST /devices HTTP/1.1\r\n"
  .."Host: "..meshbluHost.."\r\n"
  .."User-Agent: esp-lua/1.0\r\n"
  .."Accept: application/json\r\n"
  .."Content-Type: application/json\r\n"
  .."Content-Length: "..#registerPayload.."\r\n"
  .."\r\n"
  ..registerPayload

function registerWithMeshblu( callback )

    local uuid, token = loadCredentials("meshblu")
    if (uuid ~= nil and token ~= nil) then
        print("ALREADY REGISTERED WITH MESHBLU")
        return callback(nil,uuid,token)
    end

    print("SELF REGISTERING WITH MESHBLU")

    conn = net.createConnection(net.TCP, 0)

    conn:on( "receive", function(conn, payload)
        conn:close()

        print("RECEIVED MESHBLU DATA")
        data = payload:match("[^\r\n]+$")
        json = cjson.decode(data)
        uuid = (json['uuid'])
        token = (json['token'])
        saveCredentials("meshblu",uuid,token)

        if (callback ~= nil) then
            return callback(nil,uuid,token)
        end
    end )

    conn:on( "connection", function(conn)
        print("CONNECTED TO MESHBLU")
        conn:send(registerRequest)
    end )

    conn:connect(80, meshbluHost)
end
