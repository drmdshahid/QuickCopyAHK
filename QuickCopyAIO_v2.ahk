/*
made for AHK V2.0+


WHAT THIS DOES:
- quickly paste anything you have copied to a selected target window 
- select a target window --> triggered by change in clipboard (when you copy somethin)--> switches to a target window and pastes it --> switches back to your original window.


*/

SetWorkingDir A_ScriptDir  ; Ensures a consistent starting directory.

Persistent

global target:=""

MyGui := Gui(, "Quick Copy by SHAHID")
MyGui.Add("Text",, "Double click to set target:")
LV := MyGui.Add("ListView", "r20 w700", ["Name","ahk_id","ahk_class"])
LV.OnEvent("DoubleClick", LV_DoubleClick)
MyGui.Add("Button", "Default", "Refresh").OnEvent("Click", Loadlist)
myGui.OnEvent("Close", myGui_Close)
myGui_Close(thisGui) {  ; Declaring this parameter is optional.
    ExitApp
}

Loadlist()
LV.ModifyCol  ; Auto-size each column to fit its contents.
LV.ModifyCol(1, "Text")  ; For sorting purposes, indicate that column 1 is an text.



Loadlist(*)
{
	global target
	target := ""
	LV.Delete()
	ids := WinGetList(,, "Program Manager")
	for this_id in ids
	{
		;WinActivate this_id
		this_class := WinGetClass(this_id)
		this_title := WinGetTitle(this_id)
		Row := LV.Add(, this_title, this_id, this_class)
		if (Row = 0)
			break
	}
}


; Display the window and return. The script will be notified whenever the user double clicks a row.
MyGui.Show


LV_DoubleClick(LV, RowNumber)
{
    global target
	target := LV.GetText(RowNumber, 2)  ; Get the text from the row's 2nd field.
	name := LV.GetText(RowNumber)  ; Get the text from the row's first field.
    ToolTip("✓ You selected: " name)
	SetTimer () => ToolTip(), -5000
	OnClipboardChange ClipChanged
	MyGui.Minimize()
}



ClipChanged(Type) {
	;WinGetActiveTitle, source
	source := WinExist("A")
	global target
	if (target and source!=target)
	{
		WinActivate "ahk_id " target
		if (Type = 1){
			A_Clipboard := StrReplace(A_Clipboard, "`r`n", " ")
		}
		Send "^v"
		send "{Enter}"
		Sleep 500
		WinActivate "ahk_id " source
	}
}




;todo: ability to refresh the window list [DONE]
; change in title eg, addition of * to title after edit as in notepad, [DONE]
; confuses the match> making target same as source but not being detected in if expression 
; include nan option (like check box) to if new line should be omitted or kept?
; handle text and images smartly.

