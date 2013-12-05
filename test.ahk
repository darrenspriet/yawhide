#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
n = 1
store = https://www.sobeys.com/en/stores/
nowTime = %A_NowUTC%
FileCreateDir, %A_ScriptDir%\sobeys\%nowTime%
wb := ComObjCreate("InternetExplorer.Application")
wb.Visible := True
foundx=-1
foundy=-1
CoordMode Pixel, Relative
loop 289
{

store2 = %store%%A_Index%
wb.Navigate(store2)
while wb.busy or wb.ReadyState != 4
	Sleep, 10
sleep, 100
if foundx <= 1 || foundy <= 1
{
	ImageSearch, foundx, foundy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\insidebuttno.png
}
sleep,500
if foundx <= 1 || foundy <= 1
{
	ImageSearch, foundx, foundy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\saveBtn.png
	sleep, 100
}


;MsgBox The icon was found at %foundx% x %foundy% .

founda=-1
foundb=-1

Click %foundx%, %foundy%
while founda < 1 && foundb < 1
{
	ImageSearch, founda, foundb, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\uniqueafterclick.png
	sleep, 100
	if founda < 1 && foundb < 1
	{
		ImageSearch, founda, foundb, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\notfound404.png
		sleep, 100
	}
}

sleep, 100
url2 = https://www.sobeys.com/en/flyer/accessible

wb.Navigate(url2)
while wb.busy or wb.ReadyState != 4
	Sleep, 10
sleep, 100
save = % wb.document.documentElement.outerHTML
FileAppend, %save%, %A_ScriptDir%\sobeys\%nowTime%\%A_Index%.html
sleep, 500

}

MsgBox done!