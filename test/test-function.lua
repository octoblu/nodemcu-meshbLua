
local Timer = require('timer-auto')
local print = print
local Function = Function

local env = {
  print = function(str)
    print('printingly: ' .. str)
  end,
  math = math
}

local valid, result = Function.execute(env, "for i=1,10 do print(i) end return math.abs(-10)*3")
print('valid:'..tostring(valid).." - result:"..tostring(result))
