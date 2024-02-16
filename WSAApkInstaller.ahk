#Requires AutoHotkey v2.0
;@Ahk2Exe-ConsoleApp

RunShell(command) {
    shell := ComObject("WScript.Shell")
    exec := shell.Exec(A_ComSpec " /q /c " command)
    return exec.StdOut.ReadAll()
}

print(s)
{
	FileAppend s "`n", "*"
}

Global ApkFiles := Array()
Global Ret := ""

If A_Args.Length < 1
{
	print("WSA APK Installer by sadfaceman")
	print("Select APK file(s) to install")
	SelectedFile := FileSelect("M3", A_WorkingDir, "Select APK file(s) to install", "APK files (*.apk)")
	For i in SelectedFile
	{
		ApkFiles.Push i
	}
}
Else
{
	For i in A_Args
	{
		ApkFiles.Push i
	}
}
If ApkFiles.Length = 0
{
	Print("No files to install")
	Exit 0
}
Ret := RunShell("adb version")
If !Ret or !InStr(Ret, "Android Debug Bridge")
{
	Print("ADB is not installed in your system")
	Print("Install ADB here : https://developer.android.com/tools/releases/platform-tools")
	Print("If you already have ADB installed, add an environment variable to where ADB is installed")
	Exit 0
}
Ret := RunShell("adb connect 127.0.0.1:58526")
If InStr(Ret, "cannot connect to 127.0.0.1:58526")
{
	Print("[ADB] " Trim(Ret))
	Print("1. Ensure WSA is running by opening any WSA application")
	Print("2. Ensure Developer Mode is enabled")
	Print("3. Turn off VPN connections")
	Exit 0
}
If InStr(Ret, "failed to authenticate to 127.0.0.1:58526")
{
	Print("[ADB] " Trim(Ret))
	Print("1. Allow USB debugging from this PC and try again")
	Exit 0
}
Ret := RunShell("adb devices")
If !InStr(Ret, "127.0.0.1:58526")
{
	Print("ADB is not connected to 127.0.0.1:58526")
	Print("Try restarting ADB and WSA")
	Exit 0
}
Print("Installing...")
For f in ApkFiles
{
	Ret := RunShell("adb -s 127.0.0.1:58526 install `"" f "`"")
	If !InStr(Ret, "Success")
	{
		Print("[ADB] " Ret)
	}
	Else
	{
		Print(f " installed")
	}
}
; "%ProgramFiles%\AutoHotkey\v2\AutoHotkey.exe" "WSAApkInstaller.ahk" test |more
Exit 0