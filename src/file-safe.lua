local file = file

local function checkName(func)
  return function(filename, ...)
    if filename:byte(1) ~= 46 then return end
    return func(filename, unpack(arg))
  end
end

local function null() end

return {
  open = checkName(file.open),
  close = file.close,
  exists = checkName(file.exists),
  flush = file.flush,
  read = file.read,
  readline = file.readline,
  remove = checkName(file.remove),
  seek = file.seek,
  write = file.write,
  writeline = file.writeline,
  format = null,
  fscfg = null,
  fsinfo = null,
  list = null,
}
