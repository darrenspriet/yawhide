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
IEGet(Name="")
{
    IfEqual, Name,, WinGetTitle, Name, ahk_class IEFrame
        Name := ( Name="New Tab - Windows Internet Explorer" ) ? "about:Tabs"
        : RegExReplace( Name, " - (Windows|Microsoft) Internet Explorer" )
    For wb in ComObjCreate( "Shell.Application" ).Windows
        If ( wb.LocationName = Name ) && InStr( wb.FullName, "iexplore.exe" )
            Return wb
}
IELoad(wb)
{
    If !wb    ;If wb is not a valid pointer then quit
        Return False
    Loop    ;Otherwise sleep for .1 seconds untill the page starts loading
        Sleep,100
    Until (wb.busy)
    Loop    ;Once it starts loading wait until completes
        Sleep,100
    Until (!wb.busy)
    Loop    ;optional check to wait for the page to completely load
        Sleep,100
    Until (wb.Document.Readystate = "Complete")
Return True
}

loop 289
{
wb.Visible := True
store2 = %store%%A_Index%
wb.Navigate(store2)
wb.Visible := True
IELoad(wb)
sleep,1000
foundx=-1
foundy=-1
CoordMode Pixel, Relative
ImageSearch, foundx, foundy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\insidebuttno.png
if foundx <= 1 || foundy <= 1
{
	ImageSearch, foundx, foundy, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\saveBtn.png
}
;MsgBox The icon was found at %foundx% x %foundy% .
Click %foundx%, %foundy%
Click %foundx%, %foundy%
sleep, 500
url2 = https://www.sobeys.com/en/flyer/accessible
wb.Navigate(url2)
wb.Visible := true
while wb.busy
    sleep 10
save = % wb.document.documentElement.outerHTML
FileAppend, %save%, %A_ScriptDir%\sobeys\%nowTime%\%A_Index%.html
sleep, 500

}

MsgBox done!