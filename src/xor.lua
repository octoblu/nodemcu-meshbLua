return function(input, key)
  if not key then return input end
  local output = ''
  local keyindex = 1

  input:gsub(".", function(c)
    output = output .. string.char(bit.bxor(c:byte(1), key:byte(keyindex)))
    keyindex = keyindex + 1
    if keyindex > key:len() then keyindex = 1 end
  end)

  return output
end
