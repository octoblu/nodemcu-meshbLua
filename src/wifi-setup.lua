local wifiCredentials = require('wifi-credentials')

local wifi = wifi
local sntp = sntp
local print = print
local assert = assert
local rtctime = rtctime
local tostring = tostring

local Package = {}
setfenv(1,Package)

function connectAuth(network,password,callback)
  assert(network, 'network is undefined')
  print("SETUP WIFI FOR "..network)

  function doCallbackOnce(err,value)
    if callback then
      callback(err,value)
      callback = nil
    else
      print('wifi setup callback not defined or already called')
      print('ignored callback value:'..tostring(value))
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
    local sec, usec = rtctime.get()
    print(sec .. ":" .. usec)
    sntp.sync('pool.ntp.org',
      function(sec,usec,server)
        print('sync', sec, usec, server)
        local sec, usec = rtctime.get()
        print(sec .. ":" .. usec)
        doCallbackOnce(nil,wifi.sta.getip())
      end,
      function()
       print('failed!')
       doCallbackOnce(nil,wifi.sta.getip())
      end )
  --    wifi.sta.eventMonReg(wifi.STA_GOTIP, "unreg")
  end )

  wifi.sta.eventMonReg(wifi.STA_IDLE, function() print("STATION IDLE") end)
  wifi.sta.eventMonReg(wifi.STA_CONNECTING, function()print("STATION CONNECTING") end)
  wifi.sta.eventMonReg(wifi.STA_WRONGPWD, function() doCallbackOnce("STATION WRONG PASSWORD") end)
  wifi.sta.eventMonReg(wifi.STA_APNOTFOUND, function() doCallbackOnce("STATION NO AP FOUND") end)
  wifi.sta.eventMonReg(wifi.STA_FAIL, function() doCallbackOnce("STATION CONNECT FAIL") end)

  wifi.sta.eventMonStart(500)
end

function connect(callback)
  local network, password = wifiCredentials:load()
  if (network ~= nil) then
    connectAuth(network,password,callback)
  else
    print("WIFI NETWORK NOT DEFINED!")
    wifi.setmode(wifi.STATION)
    print("ENTERING SMART CONFIG MODE")
    wifi.startsmart(0, function(network, password)
      wifiCredentials:save(network,password)
      connectAuth(network,password,callback)
    end )
  end
end

return Package
