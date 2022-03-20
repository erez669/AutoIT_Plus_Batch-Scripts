@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION

set _date=%date%
set _date2=%_date:/=-%
set folder=boletbak_%_date2%
rem mkdir "%folder%"

set snif=%computername:~8,3%
net use z: /delete /y
taskkill /f /im robocopy.exe /t
mkdir "E:\%folder%\Miskalim_Sales_Statistics"
rem mkdir "E:\%folder%\data"
rem del  E:\boletbak\*.* /Q
if exist "E:\%folder%\backup" rd /q /s "E:\%folder%\backup"
mkdir "E:\%folder%\backup"

ping WLPOSSRV%snif% -n 2 -w 1000 | find "TTL=" 
if %errorlevel%==0 (set srv=wlpossrv%snif%) else (set srv=wks-%snif%-101)
if %errorlevel%==0 (set srv2=slpossrv%snif%) else (set srv=wks-%snif%-101)
REM net use z:  \\%srv%\c$ /y
if not exist \\%srv%\c$\bolet goto end
REM if not exist d:\install\robocopy\robocopy.exe call :cprobo

:cont
robocopy "\\%srv%\c$\bolet"  "E:\%folder%\backup" /R:1 /NP /NFL /MIR
robocopy "\\%srv%\snifftp\mishkalim"  "E:\%folder%\Miskalim_Sales_Statistics"  sales*.*  /R:1 /NP /NFL /MIR
robocopy "\\%srv%\c$\bolet"  "\\%srv2%\E$\%folder%\backup" /R:1 /NP /NFL /MIR
robocopy "\\%srv%\snifftp\mishkalim"  "\\%srv2%\E$\%folder%\Miskalim_Sales_Statistics"  sales*.*  /R:1 /NP /NFL /MIR

del \\%srv%\c$\bolet\data\soft_log.txt
rem del \\%srv%\c$\bolet\backup\*.* /q /s >NUL
del \\%srv2%\c$\bolet\data\soft_log.txt
rem del \\%srv2%\c$\bolet\backup\*.* /q /s >NUL

rem forfiles -P  z:\bolet\backup -s -m *.*  -d -7   -c "cmd /c del @FILE"
rem forfiles -P  z:\bolet\backup -s -m  shilut*  -d -7 -c "cmd /c del @FILE"
rem forfiles -P  z:\bolet\backup -s -m *.* -d -7 > E:\boletbak\log.txt
rem schtasks /delete /s \\wlpossrv%snif%  /tn *  /F

:end
REM net use z: /delete /y
exit /b 0

REM :cprobo
REM md d:\install\robocopy
REM net use y: /y \\posapp\c$ 
REM xcopy \\posapp\pub\robocopy.exe d:\install\robocopy\ /d
REM net use y: /delete /y
REM goto cont