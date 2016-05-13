return function(func, ...)
  local bindArgs = arg
  return function(...)
    local newArgs = arg
    local allArgs = { n = bindArgs.n + newArgs.n; 0 }
    local lastIndex = 0

    for i = 1, allArgs.n do
      allArgs[i+1] = 0
      if i <= bindArgs.n then
        allArgs[i] = bindArgs[i]
      else
        allArgs[i] = newArgs[i-bindArgs.n]
      end
      if allArgs[i] ~= nil then
        lastIndex = i
      end
    end

    return func(unpack(allArgs,1,lastIndex))
  end
end
