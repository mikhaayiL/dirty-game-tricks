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
SendMode Input
DllCall("Sleep",UInt,16.67)
Process, Priority, , High

global block := new BlockNet
block.Init()

*NumpadAdd::block.Start()
*NumpadSub::block.Stop()

class BlockNet {
	__New() {
		this.ticks := 0
		this.maxTicks := 16 ; worked perfectly for arma 3 and squad in 2018
		this.interval := 1000
		this.timer := ObjBindMethod(this, "Tick")
		this.isActiveBlockNet := false
	}

	Init() {
		Run, netsh advfirewall firewall delete rule name="blocknet" dir=in, , Hide
		Sleep 100
		Run, netsh advfirewall firewall delete rule name="blocknet" dir=out, , Hide
		Sleep 100
		Run, netsh advfirewall firewall add rule name="blocknet" action=block dir=in enable=no, , Hide
		Sleep 100
		Run, netsh advfirewall firewall add rule name="blocknet" action=block dir=out enable=no, , Hide
	}

	Start() {
		if (this.isActiveBlockNet = true) {
			this.Stop()
		} else {
			Run, netsh advfirewall firewall set rule name="blocknet" dir=in new enable=yes, , Hide
			Run, netsh advfirewall firewall set rule name="blocknet" dir=out new enable=yes, , Hide

			this.isActiveBlockNet := true
			SoundBeep, 2000, 100
			SoundBeep, 3000, 100

			timer := this.timer
			SetTimer % timer, % this.interval
		}
	}

	Stop() {
		Run, netsh advfirewall firewall set rule name="blocknet" dir=out new enable=no, , Hide
		Run, netsh advfirewall firewall set rule name="blocknet" dir=in new enable=no, , Hide
		this.isActiveBlockNet := false
		SoundBeep, 2000, 100
		SoundBeep, 1000, 100

		this.ticks := 0
		timer := this.timer
		SetTimer % timer, Off
	}

	Tick() {
		if(++this.ticks > this.maxTicks - 3) {
			SoundBeep, 500, 100
			if(this.ticks == this.maxTicks) {
				SoundBeep, 500, 100
				this.Stop()
			}
		}
	}
}