return require('bind')(mqttClient.register, mqttClient, {
  configureWhitelist = {'*'},
  discoverWhitelist = {'*'},
  receiveWhitelist = {'*'},
  sendWhitelist = {'*'},
  nodemcu = {
    chipid = node.chipid(),
    flashid = node.flashid(),
    mac = wifi.sta.getmac(),
  },
})
