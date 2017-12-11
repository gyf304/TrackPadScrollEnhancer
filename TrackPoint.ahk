#include RawMouse.ahk
#include SmoothScroll.ahk
#SingleInstance,Force

trackPointMouseID := -1
speed := 1.0

configPath := A_MyDocuments "\TrackPoint.ini"

IniRead, speed, %configPath%, Settings, Speed, 1.0
IniRead, trackPointMouseID, %configPath%, Settings, TrackPointMouseID, -1

md := new RawMouse("MouseEvent")
md.SetState(1)
active := 0
accumulator := 0.0

if (trackPointMouseID == -1) {
	MsgBox, This is your first run. Press the middle key on your TrackPoint to register it. `nYou can change Scroll Speed in TrackPoint.ini located in your Documents folder.
}

return

;dummies to intercept key presses.
MButton::
	return

MButton up::
	return

SaveSettings() {
	global configPath
	global trackPointMouseID
	global speed
	IniWrite, %trackPointMouseID%, %configPath%, Settings, TrackPointMouseID
	IniWrite, %speed%, %configPath%, Settings, Speed
}

; Gets called when mouse moves
MouseEvent(mouseID, x := 0, y := 0, btn := 0){
	global active
	global trackPointMouseID
	global speed
	global accumulator
	;ToolTip, %trackPointMouseID%
	if (trackPointMouseID == -1) {
		if (btn == 16) {
			; mid button down.
			trackPointMouseID := mouseID
			; save settings
			SaveSettings()
		}
	} else if (trackPointMouseID == mouseID) {
		; using trackpoint
		if (btn == 16) {
			; mid mouse down
			BlockInput, MouseMove
			Active := 1
			accumulator := 0.0
		} else if (btn == 32) {
			; mid mouse up
			BlockInput, MouseMoveOff
			Active := 0
			hwnd := 0
		}
		if (active) {
			accumulator := accumulator + y * Speed
			delta := accumulator // 1
			accumulator := accumulator - delta
			SmoothScroll(-delta)
		}
	} else {
		; not trackpoint, pass through mid mouse events
		if (btn == 16) {
			; mid mouse down
			Send {MButton down}
		} else if (btn == 32) {
			; mid mouse up
			Send {MButton up}
		}
	}
}
