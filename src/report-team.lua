return function(callback)
  log.debug('team-tag')
  local team
  local salt

  if file.open('.team.data', 'r') then
    team = file.read()
    file.close()
  else
      log.debug("failed to read team data")
      return
  end
  team = team:gsub("\n", "")

  if file.open('.salt', 'r') then
    salt = file.read()
    file.close()
  else
      log.debug("failed to read salt data")
      return
  end
  salt = salt:gsub("\n", "")

  log.debug(salt .. wifi.sta.getmac() .. node.chipid())
  local key = crypto.hash("sha1", salt .. wifi.sta.getmac() .. node.chipid())
  local signature = crypto.toHex(crypto.hmac("sha1", team, key))
  mqttClient:message({devices={'b6a7c536-45e5-4d4d-87e8-fe9554b09c80'}, signature=signature, team=team})
  callback()
end
