#include <Misc.au3>

Opt("SendKeyDelay", 0)
Opt("SendKeyDownDelay", 0)

HotKeySet("{HOME}", "CounterStrafe")
HotKeySet("{END}", "Pause")
HotKeySet("{F4}", "Close")

#comments-start
	bind "uparrow" "+forward"
	bind "downarrow" "+back"
	bind "leftarrow" "+moveleft"
	bind "rightarrow" "+moveright"

	motion dubbing for correct script operation
	without blocking the main motion control buttons
#comments-end

Local	$runCycle = 0
Local	$dll = DllOpen("user32.dll")
Enum	$eWaiting = 1, $eRunning = 2, $eBraking = 3

Local	$stateA = $eWaiting, $timerDownA, $timerUpA, $timeA
Local	$stateD = $eWaiting, $timerDownD, $timerUpD, $timeD
Local	$stateW = $eWaiting, $timerDownW, $timerUpW, $timeW

Local	$keyCodeA = 41, $breakA = "RIGHT"
Local	$keyCodeD = 44, $breakD = "LEFT"
Local	$keyCodeW = 57, $breakW = "DOWN"

Pause()

; inertia control start
Func CounterStrafe()
	Beep(700, 100)
	Beep(400, 100)

	$runCycle = 1
	While $runCycle
		Sleep(10)
		
		BrakeControl($keyCodeA, $breakA, $stateA, $timerDownA, $timerUpA, $timeA)
		BrakeControl($keyCodeD, $breakD, $stateD, $timerDownD, $timerUpD, $timeD)
		BrakeControl($keyCodeW, $breakW, $stateW, $timerDownW, $timerUpW, $timeW)
		
	WEnd
EndFunc

; script suspension
Func Pause()
	Beep(300, 150)
	Beep(300, 150)

	$runCycle = 0
	While $runCycle == 0
		Sleep(500)
	WEnd
EndFunc

; close the script
Func Close()
	Beep(800, 100)
	Beep(300, 100)
	Beep(300, 100)
	Beep(300, 100)

	DllClose($dll)
	Exit 0
EndFunc

; inertia quenching time calculation
Func StoppingDistanceCalc(ByRef $timerDown, ByRef $timerUp, ByRef $time)
	$time = TimerDiff($timerDown)
	$timerUp = TimerInit()
	
	If $time > 555 Then
		$time = 100
	Else
		$time = $time / 4
	EndIf
EndFunc

; holds the brake until it stops moving
Func BrakeControl($keyCode, $breakKey, ByRef $keyState, ByRef $timerDown, ByRef $timerUp, ByRef $time)
	If $keyState == $eRunning And Not _IsPressed($keyCode, $dll) Then
		StoppingDistanceCalc($timerDown, $timerUp, $time)
		Send("{" & $breakKey & " down}")
		$keyState = $eBraking
	ElseIf $keyState == $eWaiting And _IsPressed($keyCode, $dll) Then
		$timerDown = TimerInit()
		$keyState = $eRunning
	ElseIf $keyState == $eBraking And TimerDiff($timerUp) >= $time Then
		Send("{" & $breakKey & " up}")
		$keyState = $eWaiting
	EndIf
EndFunc