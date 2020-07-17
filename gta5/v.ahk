#NoEnv
#HotkeyInterval 2000
#MaxHotkeysPerInterval 2000
#KeyHistory 0
ListLines Off
SetBatchLines, -1
SetKeyDelay, -1, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
; SendMode Event ; Input|Play|Event|InputThenPlay
; DllCall("Sleep",UInt,16.67)
; Process, Priority, , High

SuspendHotkeysToggle = true
MathHotkeysToggle = false
BoostingToggle = false

<^end:: Send {Control}

*`::
	Send {L down}{� down}{END}{UP 2}{Enter}{� up}{L up}
	MouseClick, Right, , , , 0
Return

*2::Send {Numpad2}{TAB}{Numpad8}{TAB}
*3::Send {Numpad2}{TAB}{Numpad3}{TAB}
*4::
	if (BoostingToggle = "false") {
		if GetKeyState("W","P") {
			BoostingToggle = true
			While GetKeyState("W","P") {
				;Sleep, 10 ; every 10 miliseconds
				Send {S}
			}
			BoostingToggle = false
		}
	}
Return

*NumpadSub::Send {END}{Enter}{UP}{Enter 2}
*NumpadAdd::Send {END}{Enter}{UP 3}{Enter}{DOWN}{Enter}
*NumpadMult::Send {END}{DOWN 7}{Enter 3}
*Numpad9::Send {END}{DOWN 8}{Enter 3}

<^NumpadDiv::
	Suspend, Toggle
	if (SuspendHotkeysToggle = "true") {
		SuspendHotkeysToggle = false
		SoundBeep, 400, 75
		SoundBeep, 200, 125
	} else {
		SuspendHotkeysToggle = true
		SoundBeep, 300, 100
		SoundBeep, 500, 100
		SoundBeep, 500, 100
		SoundBeep, 500, 100
	}
Return

~*-::
	if (MathHotkeysToggle = "true") {
		MathHotkeysToggle = false
		SoundBeep, 400, 100
		SoundBeep, 300, 70
		SoundBeep, 200, 50
	} else {
		MathHotkeysToggle = true
		SoundBeep, 300, 50
		SoundBeep, 400, 70
		SoundBeep, 500, 100
	}
Return

~*+::
	While MathHotkeysToggle = "true" {
		Sleep, 1000
		Send {T}
		Sendinput TEST
		Send {Enter}
		Sleep, 200
		Send {T}
		Sendinput YOUR
		Send {Enter}
		Sleep, 200
		Send {T}
		Sendinput MIND
		Send {Enter}
		Sleep, 500
		Send {T}
		Sendinput NOW{!}{!}{!}
		Send {Enter}
		Sleep, 1000

		Random, VariableA, 1, 99
		Random, VariableB, 1, 99

		Random, VariableResult, 1, 4
		if (VariableResult == "1") {
			VariableResult := VariableA + VariableB
			Send {T}
			Sendinput %VariableA% {+} %VariableB% = ?
			Send {Enter}
			Sleep, 2000
			Send {T}
			Sendinput %VariableA% {+} %VariableB% = %VariableResult%
			Send {Enter}
		} else if (VariableResult == "2") {
			VariableResult := VariableA - VariableB
			Send {T}
			Sendinput %VariableA% - %VariableB% = ?
			Send {Enter}
			Sleep, 2000
			Send {T}
			Sendinput %VariableA% - %VariableB% = %VariableResult%
			Send {Enter}
		} else if (VariableResult == "3") {
			VariableResult := VariableA * VariableB
			Send {T}
			Sendinput %VariableA% * %VariableB% = ?
			Send {Enter}
			Sleep, 2000
			Send {T}
			Sendinput %VariableA% * %VariableB% = %VariableResult%
			Send {Enter}
		} else if (VariableResult == "4") {
			VariableResult := VariableA / VariableB
			Send {T}
			Sendinput %VariableA% / %VariableB% = ?
			Send {Enter}
			Sleep, 2000
			Send {T}
			Sendinput %VariableA% / %VariableB% = %VariableResult%
			Send {Enter}
		}
		Sleep, 1000
	}
Return