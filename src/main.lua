
print('setting up a main timer!')
require('timer-auto'):new({callback=function()

  print('inside main timer!')

  local WifiSetup = require('wifi-setup')
  local meshbluMqtt = require('meshblu-mqtt'):new()
  local meshbluRegister = require('meshblu-register'):new()

  local wifi = wifi
  local print = print

  setfenv(1,{})

  print('connecting to wifi')

  WifiSetup.connect( function(err, ip)
    if (err ~= nil) then
      print("! ERROR: " .. err)
      return
    end
    if (ip ~= nil) then
      print("ip: " .. ip)
      meshbluRegister:getCredentials( function( uuid, token )
        if uuid and token then
          print('uuid: ' .. uuid)
          print('token: ' .. token)
          meshbluMqtt:init( uuid, token )
        else
          print('error registering uuid and token')
        end
      end )
    end
  end )

end}):alarm(5000)
