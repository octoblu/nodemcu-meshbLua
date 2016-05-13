if file.open('.logLevel') then
  _G._LOG_LEVEL = file.readline() or "9"
  file.close()
  if not _G._LOG_LEVEL:match('^%d+$') then
    _G._LOG_LEVEL = 9
  end
end

if not file.exists('.halt') then
  _G.flag = 'pull'
  require('main')
end
