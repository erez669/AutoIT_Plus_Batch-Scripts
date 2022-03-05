#include <AutoItConstants.au3>
#include <Process.au3>

ScaleInstall()

Func ScaleInstall()
    ; Change the username and password to the appropriate values for your system.
    Local $sUserName = "administrator"
    Local $sPassword = "tiful@net1"
    Local $ComputerName = @ComputerName
    Local $FilePath = "d:\install\Weight\Megalen_scale.exe"

    ; Install Shekel OPOS with the window maximized. Program will run under the user previously specified.
    _RunDos ("start TASKKILL /f /im ~0000.exe")
    _RunDos ("start TASKKILL /f /im Megalen_scale.exe")
    RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", "d:\install\Weight\Megalen_scale.exe", "REG_SZ", "WINXPSP3")
    RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers", "d:\install\HW\Weight\Megalen_scale.exe", "REG_SZ", "WINXPSP3")
    Local $iPID = RunAs($sUserName, $ComputerName, $sPassword, $RUN_LOGON_NOPROFILE, $FilePath, "", @SW_SHOWMAXIMIZED)
    ConsoleWrite("+ PID: " & $iPID & ' - Error:'& @error & @CRLF)
    ; Wait for 4 seconds.
    Sleep(4000)

    ; Close the setup process using the PID returned by RunAs.
    ProcessClose($iPID)
EndFunc   ;==>ScaleInstall
