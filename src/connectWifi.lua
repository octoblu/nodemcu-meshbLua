function setupWifi( network, password, callback )
    print("SETUP WIFI FOR "..network)

    function doCallbackOnce(err,value)
        if (callback ~= nil) then
            callback(err,value)
            callback = nil
        end
    end

    wifi.setphymode(wifi.PHYMODE_G)
    wifi.setmode(wifi.STATION)
    wifi.sta.config(network, password)

    wifi.sta.eventMonReg( wifi.STA_GOTIP, function(Previous_State)
        if(Previous_State==wifi.STA_GOTIP) then
          print("STATION RECONNECT")
        else
          print("STATION CONNECTED")
        end
        doCallbackOnce(nil,wifi.sta.getip())
    --    wifi.sta.eventMonReg(wifi.STA_GOTIP, "unreg")
    end )

    wifi.sta.eventMonReg(wifi.STA_IDLE, function() print("STATION IDLE") end)
    wifi.sta.eventMonReg(wifi.STA_CONNECTING, function()print("STATION CONNECTING") end)
    wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() doCallbackOnce("STATION WRONG PASSWORD") end)
    wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() doCallbackOnce("STATION NO AP FOUND") end)
    wifi.sta.eventMonReg(wifi.STA_FAIL, function() doCallbackOnce("STATION CONNECT FAIL") end)

    wifi.sta.eventMonStart(500)
end
