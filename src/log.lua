local print = print

local function logLevel(level)
  return function(...)
    if (_G._LOG_LEVEL or 0)-0 < level then return end
    return print(unpack(arg))
  end
end

return {
  error = logLevel(0),
  warn  = logLevel(1),
  info  = logLevel(2),
  debug = logLevel(3),
  trace = logLevel(4),
}
