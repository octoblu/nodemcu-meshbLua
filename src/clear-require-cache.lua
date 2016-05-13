return function()
  -- log.info('cleaning up')
  -- log.info(node.heap())
  for k,v in pairs(package.loaded) do
    if k ~= '_G' and k ~= 'package' and k ~= 'protect-global' then
      -- log.debug(' -',k)
      package.loaded[k] = nil
    end
  end
  collectgarbage("collect")
  log.info(node.heap())
end
