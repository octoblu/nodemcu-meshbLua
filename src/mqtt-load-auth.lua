local action = 'mqtt-register'
local mqttCreds = require('mqtt-credentials')
if mqttCreds:exists() then
  mqttClient:setCreds(mqttCreds:load())
  action = 'game-client'
end
return action
