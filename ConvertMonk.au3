#NoTrayIcon

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TrayConstants.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>

Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
Opt("TrayAutoPause", 0)
Opt("GUIOnEventMode", 1)


Func EndlessSleep()
   While 1
       Sleep(10)
   WEnd
EndFunc


Func SaveConfig()
   $game_mouse_pos = MouseGetPos()
   IniWrite($script_name & ".ini", "Convert Monk", "Macro Convert", $convert_key)
   IniWrite($script_name & ".ini", "Convert Monk", "Pos1", $game_mouse_pos[0])
   IniWrite($script_name & ".ini", "Convert Monk", "Pos2", $game_mouse_pos[1])
   MsgBox(0, "Done", "Wrote config file! Press your macro key to test it out.")
   ReadConfig()
EndFunc


Func ReadConfig()
   HotKeySet("{F10}")
   $convert_key = IniRead($ini_directory, "Convert Monk", "Macro Convert", "")
   $convert_hotkey = "{" & $convert_key & "}"
   HotKeySet($convert_hotkey, KeyConvert)

   Global $game_mouse_pos0 = IniRead($ini_directory, "Convert Monk", "Pos1", "")
   Global $game_mouse_pos1 = IniRead($ini_directory, "Convert Monk", "Pos2", "")
EndFunc


Func KeyConvert()
   MouseClick("right")
   Send("{CTRLDOWN}")
   $mouse_pos = MouseGetPos()
   MouseClick("left", $game_mouse_pos0, $game_mouse_pos1, 1, 0)
   MouseMove($mouse_pos[0], $mouse_pos[1], 0)
   Send("{CTRLUP}")
EndFunc


Func ExitScript()
   Exit
EndFunc


$remove_au3 = StringReplace(@ScriptName, ".au3", "")
$script_name = StringReplace($remove_au3, ".exe", "")

If _Singleton(@ScriptName, 1) = 0 Then
    Exit
EndIf

TrayCreateItem("Exit Script")
TrayItemSetOnEvent(-1, "ExitScript")
TraySetState(1)

$ini_directory = @ScriptDir & "\" & $script_name & ".ini"

If Not FileExists($ini_directory) Then
   $convert_key = InputBox("Convert Key", "Enter the hotkey on your keyboard you would like to use as a macro", "", "", 200, 150)
   HotKeySet("{F10}", SaveConfig)
   MsgBox(0, "Set coordinates", "Place your mouse over the 1st selected unit in AoE2 and press F10 key as told in README.md. Click OK when ready.")
   EndlessSleep()
EndIf

ReadConfig()
EndlessSleep()
