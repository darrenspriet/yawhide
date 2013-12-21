#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
SetTitleMatchMode 2
n = 1
store = https://www.sobeys.com/en/stores/
nowTime = %A_NowUTC%
FileCreateDir, %A_ScriptDir%\sobeys\%nowTime%
flyerUrl = https://www.sobeys.com/en/flyer
flyerPage = https://www.sobeys.com/en/flyer?&gclid=COXN7_PxsLsCFfBDMgod23cAhQ&page=
page = 1
bakery = 49
beverage = 56
candy = 62
dairy = 61
deli = 48
floral = 54
grocery = 51
household = 58
meat = 43
pet = 59
produce = 45
seafood = 44
spread = 57
categUrlPart1 := "https://www.sobeys.com/en/flyer?page="
categUrlPart2 := "&products%5Bdepartment_id%5D="
categUrlPart3 := "&products%5Bq%5D=&utf8=%E2%9C%93"
j = 1

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
sleep,100
;MsgBox The icon was found at %foundx% x %foundy% .

founda=-1
foundb=-1
fou = 0
Click %foundx%, %foundy%
sleep, 300
while founda < 1 && foundb < 1
{
	ImageSearch, founda, foundb, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\uniqueafterclick.png
	sleep, 100
	if founda < 1 && foundb < 1
	{
		ImageSearch, founda, foundb, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\notfound404.png
		sleep, 100
		if founda > 1 && foundb > 1
		{
			fou = 1
		}
	}
	;MsgBox %founda% %foundb%
}
;MsgBox %fou%
if fou = 0
{
	sleep, 100
	f = -1
	g = -1
	i = 1
	;MsgBox %i% %f% %g%

	while f < 1 && g < 1 && i < 20
	{
	    url2 = %flyerPage%%i%
	    ;MsgBox %url2%
	    wb.Navigate(url2)
	    while wb.busy or wb.ReadyState != 4
			Sleep, 10
	    ;ImageSearch, f, g, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\noMorePage.png
		sleep, 100
		if f < 1 && g < 1
		{
			save = % wb.document.documentElement.outerHTML
			FileCreateDir, %A_ScriptDir%\sobeys\%nowTime%\%j%
			FileAppend, %save%, %A_ScriptDir%\sobeys\%nowTime%\%j%\%i%.html
			sleep, 100
		}
	    i++
	    ;MsgBox %i%
	}
}
j++
}

MsgBox done!