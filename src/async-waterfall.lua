return function(finished, functions, time)
  finished = finished or function()end
  functions = functions or {}
  time = time or 150

  local result = { arg={} }
  local callback = function(error, ...)
    result = { error=error, arg=arg }
  end

  Timer:new({callback=function(timer)
    if not result then return end

    if #functions == 0 or result.error ~= nil then
      timer:unregister()
      functions = nil
      return finished(result.error, unpack(result.arg))
    end

    local func = table.remove(functions)
    if type(func) == 'string' then
      func = require(func)
    end

    local nextArg = result.arg
    result = nil

    require('clear-require-cache')()
    func(callback, unpack(nextArg))
    func = nil

  end}):alarm(time, Timer.REPEAT)
end
