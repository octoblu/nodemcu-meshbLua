(function()
  -- use pin 0 as the input pulse width counter
  local pulse1 = tmr.now()
  local du = 0
  gpio.mode(3,gpio.INT)
  gpio.mode(4,gpio.OUTPUT)
  gpio.write(4,gpio.LOW)
  function trigger(level)
    du = tmr.now() - pulse1
    local val = gpio.read(3)
    if (val==0) then
      print(du)
      pulse1 = tmr.now()
      gpio.write(4,gpio.HIGH)
    else
      gpio.write(4,gpio.LOW)
    end
  end
  gpio.trig(3, "both", function(level)
    tmr.alarm(4, 15, 0, trigger )
  end )
end)()
