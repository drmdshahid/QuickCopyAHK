#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; #Persistent

Gui, Font, s9, Verdana    ; Set 10-point Verdana.
Gui, Add, Text,, [Script to quickly paste into a target window on copying.] `n`nDouble-click to select a target window:

; Create the ListView with two columns, Name and class:
Gui, Add, ListView, r20 w700 gMyListView, ahk_class |Name|ahk_id | PID

PopulateList:
; Gather a list of windows into the ListView:
WinGet, id, List,,, Program Manager
Loop, %id%
{
    this_id := id%A_Index%
    WinGetClass, this_class, ahk_id %this_id%
    WinGetTitle, this_title, ahk_id %this_id%
    WinGet, this_pid, PID, ahk_id %this_id%
    LV_Add("", this_class, this_title, this_id, this_pid)
}

LV_ModifyCol(1)  ; Auto-size each column to fit its contents.
LV_ModifyCol(2, 150)
; LV_ModifyCol(2, "Integer")  ; For sorting purposes, indicate that column 2 is an integer.

Gui, Add, Button, Default, RELOAD
Gui, Add, CheckBox, vPause, Pause this script?

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show
return

ButtonRELOAD:
; MsgBox % "i shall reload"
LV_Delete()
Goto, PopulateList
return




MyListView:
if (A_GuiEvent = "DoubleClick")
{
    global target
    LV_GetText(target, A_EventInfo, 3)  ; Get the text from the row's 3nd field.i.e ahk_id 
    LV_GetText(targetName, A_EventInfo, 2)
    TrayTip, Quick copy, target: "%targetName%", 10, 1
    OnClipboardChange("ClipChanged")
    Gui, Minimize
}
return

ClipChanged(Type) {
	;WinGetActiveTitle, source
    	WinGet, source, ID, A 		; get id of active window
	global target
        GuiControlGet, Pause
	if (target and source!=target and Pause!=1)
	{
		WinActivate, ahk_id %target%
		Send, ^v
		Sleep 200
		Send, {Enter}
		Sleep 200
		WinActivate, ahk_id %source%
	}
}


GuiEscape:
GuiClose:  ; Indicate that the script should exit automatically when the window is closed.
ExitApp




;todo: ability to refresh the wondow list
; change in title eg, addition of * to title after edit as in notepad, 
; confuses the match> making target same as source but not being detected in if expression
;
