@set @port=%1
@echo push enter to flash on %@port% or ctrl-c and gtfo
@pause

@set @luatool=cactuscon-nodemcu-meshblua\luatool\luatool\luatool.py

@set @port=%1
@set @team=%2
@set @flasher=c:\Python27\python.exe esptool-master\esptool.py -p %@port% write_flash 0x0 nodemcu-dev-13-modules-2016-05-03-23-39-15-integer.bin

@echo %@port%
@echo %@team%
@echo %@flasher%
@echo Flashing %@port%
%@flasher%

@echo please hit the reset button on the device...
@echo when done hit enter
pause


@echo %@team% > cactuscon-nodemcu-meshblua\src\.team.data
%@luatool% -p %@port% -f cactuscon-nodemcu-meshblua\setup\pre-upload.lua --baud 115200 --delay 0.05
%@luatool% -p %@port% -f cactuscon-nodemcu-meshblua\setup\pre-upload.lua --baud 115200 --delay 0.05
for /r %%i in (cactuscon-nodemcu-meshblua\src\*.lua) do c:\Python27\python.exe %@luatool% -f %%i -p %@port% --baud 115200 --delay 0.05
for /r %%i in (cactuscon-nodemcu-meshblua\src\.*) do c:\Python27\python.exe %@luatool% -f %%i -p %@port% --baud 115200 --delay 0.05
%@luatool% -p %@port% -f cactuscon-nodemcu-meshblua\setup\post-upload.lua --baud 115200 --delay 0.05 -d