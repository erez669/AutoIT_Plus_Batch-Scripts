@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

set _date=%date%
set _date2=%_date:/=-%
set folder=boletbak_%_date2%

set snif=%computername:~8,3%
net use z: /delete /y
taskkill /f /im robocopy.exe /t
mkdir "E:\%folder%\Miskalim_Sales_Statistics"
if exist "E:\%folder%\backup" rd /q /s "E:\%folder%\backup"
mkdir "E:\%folder%\backup"

ping WLPOSSRV%snif% -n 2 -w 1000 | find "TTL=" 
if %errorlevel%==0 (set srv=wlpossrv%snif%) else (set srv=wks-%snif%-101)
if %errorlevel%==0 (set srv2=slpossrv%snif%) else (set srv=wks-%snif%-101)
if not exist \\%srv%\c$\bolet goto end

:cont
robocopy "\\%srv%\c$\bolet"  "E:\%folder%\backup" /R:1 /NP /NFL /MIR
robocopy "\\%srv%\snifftp\mishkalim"  "E:\%folder%\Miskalim_Sales_Statistics"  sales*.*  /R:1 /NP /NFL /MIR
robocopy "\\%srv%\c$\bolet"  "\\%srv2%\E$\%folder%\backup" /R:1 /NP /NFL /MIR
robocopy "\\%srv%\snifftp\mishkalim"  "\\%srv2%\E$\%folder%\Miskalim_Sales_Statistics"  sales*.*  /R:1 /NP /NFL /MIR

del \\%srv%\c$\bolet\data\soft_log.txt
del \\%srv2%\c$\bolet\data\soft_log.txt

:end
exit /b 0
