return function(callback)
  log.debug('sntp-sync')
  local sec, usec = rtctime.get()
  sntp.sync('pool.ntp.org',
    function(sec,usec,server)
      log.debug(sec)
      callback()
    end,
    function()
     log.error('failed ntp sync!')
     callback()
    end )
end
