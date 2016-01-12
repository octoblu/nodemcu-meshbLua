local prefix="."
local suffix=".data"

function loadCredentials( filename )
  local filename = prefix .. (filename or "") .. suffix
  if (file.open(filename,"r")) then
    local data = file.read()
    file.close()
    local name, value = string.match(data, "([^\n]*)\n([^\n]*)")
    return name, value
  end
end

function saveCredentials( filename, name, value )
  local filename = prefix .. (filename or "") .. suffix
  local data = (name or "") .. "\n" .. (value or "")
  file.remove(filename)
  file.open(filename,"w+")
  file.write(data)
  file.flush()
  file.close()
end
