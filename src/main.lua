require("connectWifi")
require("credentials")
require("register")
require("connectMqtt")

local function connect( network, password )
  setupWifi( network, password, function(err, ip)
    if (err ~= nil) then
      print("! ERROR: " .. err)
      return
    end
    if (ip ~= nil) then
      print("ip: " .. ip)
      registerWithMeshblu( function( err, uuid, token )
        print('uuid: ' .. uuid)
        print('token: ' .. token)
        init_mqtt( uuid, token )
      end )
    end
  end )
end

local network, password = loadCredentials("wifi")
if (network == nil) then
  print("WIFI DATA DOES NOT EXIST!")
  wifi.setmode(wifi.STATION)
  print("ENTERING SMART CONFIG MODE")
  wifi.startsmart(0, function(network, password)
    saveCredentials("wifi",network,password)
    connect(network,password)
  end )
else
  connect(network,password)
end
