; Stian Coward, 
;2015.11.08	- Initial version
;
; Tested on Win7 on versions:
; Spotify: 	1.0.16.104.g3b776c9e
; Opera: 	33.0.1990.58
; Chrome: 	46.0.2490.80 m
; Firefox: 	42.0
; IE:  		11.0.9600.17691
;
;2016.07.15 - Edited timings etc. 
;           - Removed IE function to show song name in address bare after search.
;	    - .exe built with AHK 1.1.24.00 Unicode 32-bit
; Tested on Win10 on version:
; Spotify: 	1.0.33.106.g60b5d1f0
; Opera: 	38.0.2220.41 
; Chrome: 	51.0.2704.106 m
; Firefox: 	46.0.1
; IE:  		11.420.10586.0
;
;2018.02.12 - Added Edge browser support.
;	    - .exe built with AHK 1.1.24.00 Unicode 32-bit
; Tested on Win10 on version:
; Spotify: 	1.0.73.345.g6c9971ef
; Opera: 	51.0.2830.26
; Chrome: 	64.0.3282.140 (64-bit)
; Firefox: 	58.0.2 (64-bit)
; IE:  		11.633.10586.0
; Edge:         25.10586.0.0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 
;INFO
; For PLAY/ PAUSE push: F12,
; For Next: F11,
; For Previous: F10, 
; F9: Open new Opera/Firefox/Chrome/IE-tab and search for "artist" - "title" "chords" 
;     (playing in spotify), and insert title in adress-bar. A browser and Spotify needs to be open before pressing hotkey.


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#NoEnv ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input ; Recommended for new scripts due to its superior speed and reliability.
SetTitleMatchMode 2 

#Persistent 
return 


; "F12"  for play pause 
F12::Media_Play_Pause

; "F10"  for previous 
F10::Media_Prev

; "F11"  for next 
F11::Media_Next

; "F9"  for artist- song to clipboard and search with browser
F9:: 
{ 
	Process, Exist, spotify.exe ; check to see if process is running
	IF !errorlevel=0
	{
		Process, Exist, opera.exe ; check to see if process is running
		IF !errorlevel=0
		{
			WinGetTitle, playing, ahk_class SpotifyMainWindow 
			clipboard=%playing%
			StringSplit, word_array, playing,"-",
			word = %word_array2% ; Select second element in the array (artist - title) -> title
			word := RegExReplace(word, "\'", "") ; remove the special character "'" from the text to be inserted in the address field. Causes search against favorites to miss since fav-names normally does not include them.
			
			WinActivate , ahk_class Chrome_WidgetWin_1
			sleep 50
			Send ^t
			sleep 50
			Send %playing% chords
			Send {Enter}
			sleep 200
			Send {F8}
			sleep 100
			Send %word%
			return
		}	
		
		Process, Exist, firefox.exe ; check to see if firefox.exe is running
		IF !errorlevel=0
		{
			WinGetTitle, playing, ahk_class SpotifyMainWindow 
			clipboard=%playing%
			StringSplit, word_array, playing,"-",
			word = %word_array2% ; Select second element in the array (artist - title) -> title
			word := RegExReplace(word, "\'", "") ; remove the special character "'" from the text to be inserted in the address field. Causes search against favorites to miss since fav-names normally does not include them.

			WinActivate , ahk_class MozillaWindowClass
			sleep 80
			Send ^t
			sleep 100
			Send %playing% chords
			Send {Enter}
			sleep 900
			Send {F6}
			sleep 200
			Send %word%
			return		
		}	
		
		Process, Exist, chrome.exe ; check to see if process.exe is running
		IF !errorlevel=0
		{
			WinGetTitle, playing, ahk_class SpotifyMainWindow 
			clipboard=%playing%
			StringSplit, word_array, playing,"-",
			word = %word_array2% ; Select second element in the array (artist - title) -> title
			word := RegExReplace(word, "\'", "") ; remove the special character "'" from the text to be inserted in the address field. Causes search against favorites to miss since fav-names normally does not include them.

			WinActivate , ahk_class Chrome_WidgetWin_1
			sleep 50
			Send ^t
			sleep 100
			Send %playing% chords
			sleep 50
			Send {Enter}
			sleep 300
			Send {F6}
			sleep 300
			Send %word%
			return		
		}		
		
		Process, Exist, iexplore.exe ; check to see if process.exe is running
		IF !errorlevel=0
		{
			WinGetTitle, playing, ahk_class SpotifyMainWindow 
			song = %playing%
			StringSplit, word_array, playing,"-",
			word = %word_array2% ; Select second element in the array (artist - title) -> title
			word := RegExReplace(word, "\'", "") ; remove the special character "'" from the text to be inserted in the address field. Causes search against favorites to miss since fav-names normally does not include them.
			playing := RegExReplace(playing, " ", "{+}") ; prepare URL, insert + between words
			text := RegExReplace(playing, "&", "%26") ; prepare URL, replace & with ansi
						
			searchtext :="https://www.google.com/search?q=" ; Url used as basis for search
			WinActivate , ahk_class IEFrame
			sleep 100
			Send ^t
			sleep 200
			Send {F4}
			;clipboard=%searchtext%%text%{+}chords
			sleep 200	
			Send, %searchtext%%text%{+}chords
			;Send ^v
			sleep 200	
			Send {Enter}
			;give up on showing song name afterwards... IE sucks
			;sleep 100
			;Send {F4}
			;sleep 100
			;Send {F4}
			;sleep 100
			;Send %word%			
			;clipboard=%song% ; For convenience.
			;msgBox %text%
			
			return		
		}	

		Process, Exist, MicrosoftEdge.exe ; check to see if process.exe is running
		IF !errorlevel=0
		{
			WinGetTitle, playing, ahk_class SpotifyMainWindow 
			song = %playing%
			StringSplit, word_array, playing,"-",
			word = %word_array2% ; Select second element in the array (artist - title) -> title
			word := RegExReplace(word, "\'", "") ; remove the special character "'" from the text to be inserted in the address field. Causes search against favorites to miss since fav-names normally does not include them.
			playing := RegExReplace(playing, " ", "{+}") ; prepare URL, insert + between words
			text := RegExReplace(playing, "&", "%26") ; prepare URL, replace & with ansi
						
			searchtext :="https://www.google.com/search?q=" ; Url used as basis for search
			WinActivate , ahk_class ApplicationFrameWindow
			sleep 100
			Send ^t
			sleep 200
			;Send {F4}
			;clipboard=%searchtext%%text%{+}chords
			;sleep 200	
			Send, %searchtext%%text%{+}chords
			;Send ^v
			sleep 200	
			Send {Enter}
			;give up on showing song name afterwards... IE sucks
			;sleep 100
			;Send {F4}
			;sleep 100
			;Send {F4}
			;sleep 100
			;Send %word%			
			;clipboard=%song% ; For convenience.
			;msgBox %text%
			
			return		
		}		
		
		MsgBox % "A browser needs to be running for this hotkey."
		
	}
	else
	MsgBox % "Spotify needs to be running for this hotkey."
	return
} 