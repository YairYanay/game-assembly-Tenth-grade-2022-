IDEAL
MODEL small

STACK 0f500h


MACRO NEW_LINE
	mov dl,13   ; CR = Caridge Return - go to row start position
	mov ah,2   
	int 21h
	mov dl,10   ;  LF = Line Feed - go down to the next line
	int 21h
ENDM


macro randomColors FirstrndNum,SecondrndNum
;  random numbers in range of 1-255
	 mov bl,FirstrndNum
	 mov bh,SecondrndNum 
	 call RandomByCs
endm


macro delay TimeToDelay
    mov cx,TimeToDelay
    mov dx,1
    mov ah,86h
    int 15h
endm


macro CalculateTime ActionToCall
	local @@exit

    mov ah, 2Ch
    int 21h
	
    cmp dh, [TimeGet]
    je @@exit
	
    mov [TimeGet], dh
	
	;action
	call ActionToCall

@@exit:
endm


macro printtime TimerLookPrint,NumberPrint,XPos,Ypos
	mov ax,1301h
	xor bh,bh
	mov bl,11111111b				;color
	mov cx,NumberPrint            ;number of characters in string
	mov dh,Ypos
	mov dl,XPos
	push ds
	pop es
	mov bp,offset TimerLookPrint
	int 10h
	
	;Put the cursor in the middle-upper part
    ;mov ah, 2
    ;mov dl, 17
    ;xor dh, dh
    ;int 10h
	
	;mov dx, offset TimerLookPrint
	;mov ah, 9h
	;int 21h
endm


macro PrintScoreWin ScorePrint, NumberPrint,XPos,Ypos
	mov ax,1301h
	xor bh,bh
	mov bl,11111111b				;color
	mov cx,NumberPrint            ;number of characters in string
	mov dh,Ypos
	mov dl,XPos
	push ds
	pop es
	mov bp,offset ScorePrint
	int 10h
	
	;Put the cursor in the middle-upper part
    ;mov ah, 2
    ;mov dl, 17
    ;xor dh, dh
    ;int 10h
	
	;mov dx, offset TimerLookPrint
	;mov ah, 9h
	;int 21h
endm


macro PrintScore Score,XPos,Ypos
	mov dh, Ypos
	mov dl, XPos
	mov bh, 0
	mov ah, 2
	int 10h
	
	mov ax,[Score]
	call ShowAxDecimal
endm



macro CheckIfFileExist FileName
@@CheckFileExist:
    ;Check Exist at Open File
    mov al,2
    mov dx,offset FileName
    mov ah,3dh
    int 21h
	mov [fhandle],ax
	jnc @@exit
	
@@carryFlage1:
	cmp ax,2
	jne @@exit
	
@@CreateFile:
    ;Create File
    mov al,0
    mov dx,offset FileName
    mov ah,3Ch
    int 21h
    mov [fhandle],ax
	
@@exit:
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h

endm

;File Settings
OptionFileName equ 'Option.bmp'
TableScoreFileName equ 'SCRtable.bmp'
HelpPageInfo equ 'InfoWBg.bmp'
Text1Help equ 'HPText1.bmp'
Text2HelpP equ 'HPText2.bmp'
Text3HelpP equ 'HPText3.bmp'
IconGame equ 'IconGame.bmp'
GamePicFileName equ 'Gamepic.bmp'
EndGameFileName equ 'EndGame.bmp'
VictoryGameFineName equ 'VictoryG.bmp'
loginFileName equ 'LoginP.bmp'
registerFileName equ 'Register.bmp'
nowriteFileName equ 'noWriteP.bmp'
NotCorrectLogInFileName equ 'NCorrect.bmp'


BMP_WIDTH = 320
BMP_HEIGHT = 200

SMALL_BMP_HEIGHT = 40
SMALL_BMP_WIDTH = 40

TimeBack = 5
TimeStarted = 0


;Score
	StartScore = 0
	AddScoreSuc = 1000
	EndWinGameScore = 1000

DATASEG
    OneBmpLine  db BMP_WIDTH dup (0)  ; One Color line read buffer
   
    ScrLine     db BMP_WIDTH dup (0)  ; One Color line read buffer
    
    ;option picture
    OptionPicture db OptionFileName, 0
	TableScorepicture db TableScoreFileName, 0
    HelpInfoPicture db HelpPageInfo, 0
	Text1InHelpPage db Text1Help, 0
    Text2InHelpPage db Text2HelpP, 0
    Text3InHelpPage db Text3HelpP, 0
	IconGamePic db IconGame, 0
	GamePhoto db GamePicFileName, 0
	EndGamePic db EndGameFileName, 0
	VictoryBlind db VictoryGameFineName, 0
	logInPage db loginFileName, 0 
	RegisterPagePic db registerFileName, 0
	noWriteInPassUser db nowriteFileName,0
	NotCorrectLogInPic db NotCorrectLogInFileName, 0
    
    BmpFileErrorMsgHelp db 'Error At Opening Bmp File ',HelpPageInfo, 0dh, 0ah,'$'
    BmpFileErrorMsg     db 'Error At Opening Bmp File ',OptionFileName, 0dh, 0ah,'$'
    ErrorFile           db 0
        
    Header      db 54 dup(0)
    Palette     db 400h dup (0)
    
    ;File Handle
    FileHandle dw ?
    
    ;BMP Place
    BmpLeft dw ?
    BmpTop dw ?
    BmpColSize dw ?
    BmpRowSize dw ?

    ;Draw square
    SquareSize dw ?
	squareYpEnd dw ?

    ;Draw Buttons
    Color db ?
    Xclick dw ?
    Yclick dw ?
    Xp dw ?
    Yp dw ?
    LineSize dw ?
    SideSize dw ?
    printLine2 dw 0
    
    ;Clicks
    clickRight db "You Click Right",'$'
    clickLeft db "You Click Left",'$'
    GotClick dw ?
    
    ;Possetion Of Mouse
    clickPosX dw ?
    clickPosY dw ?
    
    ;Buttons End or return Game
	EndGameBtn db 0  
	ReturnBtn db 0 
	
    
    ;Pages
    SoundHelpPage db 0 ;off-0, on-1,
    whichPage db 0 ;menu = 0, ExitPgae = 1, GamePage = 2, HelpPage = 3,
    WhichTextInHelpP db 0 ;0-none, s1-??? ????, s2-?? ????? ?? ????????, s3-??? ????? ?? ??????? ?????, s4-???? ??????, s5-???? ??????
	ExitTextPage db 0 ;0-none , 1-Exit To Help Page
    
    HelpPageName db "Help Page",'$'
    MenuPageName db "Menu Page",'$'
    
    ;Note
    BB db "BB... pls Come Back",'$'
    
    
    ;Sound
    ;incbin "Sound.mp3"                   ;280,753 bytes ; Includes file1 if it exists in the current place
    ;AREA    Ex
    ;INCBIN  Sound.dat                    ; Includes file1 if it exists in the current place
    ;sound_index dw 0
    fileNameSound db "sound.txt", 0
    fhandle dw ?
    datatowriteOn db '1'
    datatowriteOff db '0'
	
	;random 
	RndCurrentPos dw start
	rndNumColor1 db ?
	rndNumColor2 db ?
	
	
	;color
	ChangeColor db ?
	YouSucceeded db ?
	YouLose db ?
	
    	;piccc
	;pic db "VG"
	;pivnum db "0.bmp",0
	
	;timer Until End
	SecondsTime db 0
	MinutesTimes db 0
	hoursTime db 0
	TimerLook db "00:00:00"
	Pass24H db "224 hours have passed I'm taking you out bye$"
	YouOut24HPass db 0
	
	
	;timer
	TimerLookBack db "00"
	TimeBackTo0 db TimeBack
	TimeGet db ?
	True1SecMove db ?
	EndGameTime db 0
	
	;Score
	VictoryGame db 0 ;o-none, 1- on
    Score dw StartScore
	
	;Max Score
	maxScore dw 0
	lengthScore dw 4
	maxScoreSort db 5 dup(?)
	WriteToScoreFile db '00000'
	FileNameMaxScore db "MaxScore.txt", 0
	
	
	;Log In
	tavFromLogInFile db ?
	LengthCall dw 0
	LengthLines dw 0
	RegisterLogInPage db 0 ;1-login , 2-Register
	LogInFile	db "LogIn.txt", 0
	nametoWrite db 8 dup(?)
	counterNameLength dw 0
	dontTypeAnyThing db 0   ;Show if the type in a password and a User name
	
	
	passwordtoWrite db 8 dup(?)
	counterPasswordLength dw 0
	
	ExclamationMark db '!'   ;Show a Accounts, Before Account
	dollarWrite db '$'       ;Show between information  (Password,User Name...)
	
	LogInInfoClickUserPass dw 0 ;o-none, 1-user Name, 2-Password
	
	SubmitBTNClick db 0  ;1-click BTN, 0-Not Click BTN
	
	UserPassIdfromFile db ?
	UserName db 8 dup(?)
	UserNameLength dw 0
	Password db 8 dup(?)
	PasswordLength dw 0
	
	PassAndUSerExist db 0 ;1-Exist , 2-Not Exist
	CorrectTavInUser dw 0
	CorrectTavInPass dw 0
	
	CheckIfNeedPutScoreToFile db 0
	
	EOF db 0 ;0-Not End of file , 1-End of file
	EndOfFile dw 0  ;the number End
	
	;New Line
	newLine db 13,10
	
    TapMaskMouse    dw 1111001111111111b
            dw 1110110111111111b
            dw 1110110111111111b
            dw 1110111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b
            dw 1111111111111111b

            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 1111111011111111b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
            dw 0000000100000000b
	
CODESEG
start:
    mov ax, @data
    mov ds, ax
	
	
    call SetGraphic
	
	call IconGamePrintPic
	
	delay 15h

    ; set mouse pointer
    xor ax,ax
    int 33h 
	
	; Show mouse pointer
    mov ax,1
    int 33h 


login:
	call LogInPrintPic
	
	; Show mouse pointer
    mov ax,1
    int 33h 
	
	delay 2h
	jmp LogInPageScreen
	

NotCorrectPassOrUserlogin:
	call NotCorrectLogInPrintPic
	
	call ResetButtonsData
	mov [dontTypeAnyThing], 0
	mov [SubmitBTNClick], 0
	mov [counterPasswordLength], 0  ;reset to start from begin
	mov [counterNameLength], 0

	
	; Show mouse pointer
    mov ax,1
    int 33h 
	
	
	delay 2h
	

LogInPageScreen:
	;Check Exit
	call CheckLeave
	cmp [WhichPage],1 ;Exit Page
    je JumpToLabelToEXit1
	
	call ResetButtonsData
	
	call CheckClickInLogInPage ;Check Where Write	
	
		
	call WriteNameInScreen ;Write And Print The name
	
;check Submit Button click
	cmp [SubmitBTNClick],1
	je CheckPassUserExistInFile
	
	
	call CheckClickRegisterPage  ;Chekc If Click Register page
	cmp [RegisterLogInPage], 2
	je printRegisterPic
	
	jmp LogInPageScreen

JumpToLabelToEXit1:
	jmp JumpToLabelToEXit
	
noWriteUserOrPAssLoginP:
	call PrintnoWritePage
	
	; Show mouse pointer
    mov ax,1
    int 33h 
	call ResetButtonsData
	mov [dontTypeAnyThing], 0
	mov [SubmitBTNClick], 0
	mov [counterPasswordLength], 0  ;reset to start from begin
	mov [counterNameLength], 0
	jmp LogInPageScreen

jumpToNotCorrectPassOrUserlogin:
	mov ax, [LengthCall]
	sub ax, 5
	mov [EndOfFile], ax
	mov [LengthCall],0
	jmp NotCorrectPassOrUserlogin


CheckPassUserExistInFile:
;Check If Not Write Any Things
	call CheckIfUserAndPassCorrect
	cmp [dontTypeAnyThing], 1
	je noWriteUserOrPAssLoginP
	;Check if user and pass exist
CheckAllFileUserAndPass:
	mov [UserNameLength], 0
	mov [PasswordLength], 0
	call putTavinUser      ;Put User And Pass from file
	call CheckIfUserAndPassTrue  ;Check If User and Pass Correct
	cmp [PassAndUSerExist], 1
	je jumptoMenuPageL
	cmp [EOF], 1
	je jumpToNotCorrectPassOrUserlogin
	jmp CheckAllFileUserAndPass
	
jumptoMenuPageL:
	jmp MenuPageL
	
JumpToLabelToEXit:
	jmp JumpToEXit

	;Register Screen
printRegisterPic:
	
	; Head mouse pointer
    mov ax,2
    int 33h 
	
	call PrintRegisterPage
	
	; Show mouse pointer
    mov ax,1
    int 33h 
	
	delay 2h
RegisterPageScreen:
	;Check Exit
	call CheckLeave
	cmp [WhichPage],1 ;Exit Page
    je JumpToLabelToEXit
	
	call ResetButtonsData
	
	call CheckClickInLogInPage ;Check Where Write	
	
		
	call WriteNameInScreen ;Write And Print The name
	
	;check Submit Button click 
	cmp [SubmitBTNClick],1
	je PutUserPassInputToFile
	
	call CheckClickLogInPage  ;Chekc If Click LogIn page ;Now Yet
	cmp [RegisterLogInPage], 1
	je jumptologin	
	jmp RegisterPageScreen


jumptologin:
	jmp login
	
noWriteUserOrPAssRegisterP:
	call PrintnoWritePage
	
	; Show mouse pointer
    mov ax,1
    int 33h 
	call ResetButtonsData
	mov [dontTypeAnyThing], 0
	mov [SubmitBTNClick], 0
	mov [counterPasswordLength], 0 
	mov [counterNameLength], 0
	jmp RegisterPageScreen
	
	

PutUserPassInputToFile:
	call CheckIfUserAndPassCorrect
	cmp [dontTypeAnyThing], 1
	je noWriteUserOrPAssRegisterP
	CheckIfFileExist LogInFile
	call WriteUserPassToFile
	call PutScoreInFile
	

MenuPageL:
	;Reset Full Time
	mov [SecondsTime],TimeStarted
	mov [MinutesTimes],TimeStarted
	mov [hoursTime],TimeStarted
		
	
    call MenuPage
    
    ; Show mouse pointer
    mov ax,1
    int 33h 

    call CheckClickButtons

    cmp [WhichPage],1 ;Exit Page
    je JumpToEXit
    
    cmp [WhichPage],2 ;GamePage
    je GamePageCall
    
    cmp [WhichPage],3 ;Help Page
    je JmpToHelpPageCall
	
	cmp [whichPage], 4  ;Score Table
	je ScoreTableCall
    
JumpToEXit:
	jmp exit
    
JmpToHelpPageCall:
	jmp HelpPageCall
	
	
ScoreTableCall:
	call PrintTableScorePic
	
	; Show mouse pointer
    mov ax,1
    int 33h 
CheckLeaveTableScore:
	call CheckLeave
	cmp [WhichPage],1 ;Exit Page
	je GotoMenuPage
	jmp CheckLeaveTableScore

GotoMenuPage:   ;and reset settings
	call ResetButtonsData
	mov [WhichPage], 0
	delay 1h
	jmp MenuPageL
	
	
	
GamePageCall:
	;Check if file exist
	CheckifFileExist FileNameMaxScore

	;Reset TimeBack and Data
	mov [TimeBackTo0], TimeBack
	mov [EndGameTime], 0
	call ResetButtonsData
	
	;Reset Full Time
	mov [SecondsTime],TimeStarted
	mov [MinutesTimes],TimeStarted
	mov [hoursTime],TimeStarted
	call updatetimerUntingEndGame
	
	delay 1h

    ; Head mouse pointer
    mov ax,2
    int 33h 
    
    call GamePic
	
	; show mouse pointer
    mov ax,1
    int 33h 
   
Game_Suc_loop:
	Delay 2h
	
	; show mouse pointer
    mov ax,2
    int 33h 
	
	call PrintColorAndChangeColor
	
	; show mouse pointer
    mov ax,1
    int 33h 

Click_OutSide_Loop:
	;score
	;call PrintScore
	PrintScore score,31,4
	call CheckFinishGame
	cmp [VictoryGame], 1
	jne Jump_TO_Win_Victory
	jmp WinVictory
	
Jump_TO_Win_Victory:
	;Timer full time
	CalculateTime inctimer
	call updatetimerUntingEndGame
	
	cmp [YouOut24HPass], 1
	je Lose ;jump to out of range


	;End Time
	call updatetimer
	printtime TimerLookBack,2,6,4
	CalculateTime DecToTimer
	call CheckEndGameZero
	cmp [EndGameTime], 1
	je Lose

	call Check_Click_Different_Color
	
	cmp [YouSucceeded],1
	je succeeded
	
	cmp [YouLose],1
	je Lose
	
	jmp Click_OutSide_Loop
	

succeeded:
	;Reset TimeBack and Data
	mov [TimeBackTo0], TimeBack
	mov [EndGameTime], 0
	call ResetButtonsData

	mov [YouSucceeded],0
	
	call AddScore
	
	jmp Game_Suc_loop


Lose:
	; show mouse pointer
    mov ax,2
    int 33h 
	
	call EndGame
	
	;Put Max Score on File
	call readMaxScoreFile
	call CheckMaxScore
	
	;Print Max Score
	PrintScore maxScore,22,14
	
	;print Full Timer 
	printtime TimerLook,8,19,16
	
	;Print Score
	PrintScore Score,19,13
	
	;Reset TimeBack and Data
	mov [TimeBackTo0], TimeBack
	mov [EndGameTime], 0
	call ResetButtonsData
	
	
	; show mouse pointer
    mov ax,1
    int 33h 
	
	mov [Score], StartScore
	
	jmp ButtonsToExitOrReturn
	
	
WinVictory:
	; show mouse pointer
    mov ax,2
    int 33h 
	
	call VictoryGameWin
	
	;Put Max Score on File
	call readMaxScoreFile
	call CheckMaxScore
	
	;Print Max Score
	PrintScore maxScore,22,14
	
	;print Full Timer 
	printtime TimerLook,8,19,16
	
	;Print Score
	PrintScore score,19,13
	
	;Reset TimeBack and Data
	mov [TimeBackTo0], TimeBack
	mov [EndGameTime], 0
	mov [Score], StartScore
	mov [VictoryGame], 0
	call ResetButtonsData
	
	
	; show mouse pointer
    mov ax,1
    int 33h 
	
ButtonsToExitOrReturn:
	call EndGameButtons
	
	delay 3h
	
	cmp [ReturnBtn], 1
	je jumpToGamePageCall
	
	cmp [EndGameBtn], 1
	je JumpMenuPageL
	
	jmp ButtonsToExitOrReturn

jumpToGamePageCall:
	mov [ReturnBtn], 0
	mov [Score], StartScore
	jmp GamePageCall

JumpMenuPageL:
	mov [EndGameBtn], 0
	jmp MenuPageL
   
   
   
HelpPageCall:
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
    call HelpPage1
    
    ; Head mouse pointer
    mov ax,1
    int 33h

hPUntilExit:
    call HelpPageAnyButton
	
	cmp [WhichPage],0 ;Menu Page
    jne continue
    
jumpToMenuPage:
	jmp MenuPageL
    
	
continue:
	CheckIfFileExist fileNameSound
    
	call HelpPageSoundBtn
    
    call WhatTextClick
    
    ; Head mouse pointer
    mov ax,1
    int 33h 
    
HelpPageInText:
    call TextExitP
	
	;Delay
	Delay 1h
	
    cmp [ExitTextPage],1 ;Help Page
    jne HelpPageInText
    
	call ResetButtonsData
	
jumpToHelpPage:
	jmp hPUntilExit
    
    

exit:

    mov ax,3
    int 10h

    mov ax, 4c00h
    int 21h
	
;==========================
;==========================
;===== Procedures  Area ===
;==========================
;==========================
;מטרת: לבדוק אם איפה לחץ אם זה בUSER או בPASSWORD או בSUBMIT
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם נלחץ על PASSWORD יכניס 2LogInInfoClickUserPass  למשתנה אם בUSER יכניס  LogInInfoClickUserPass1 לאותו מישתנה אבל אם זה לSUBMIT יכניס אחד למשתנה SubmitBTNClick

proc CheckClickInLogInPage
	call Click_Pos
	
	cmp [GotClick], 1
	jne @@exit
	
	;User Name Button in Log In Page
check_Click_UserName_In_LogIn_Page:
    cmp [clickPosX],296
    jb check_Click_Password_In_LogIn_Page
    cmp [clickPosX],428
    ja check_Click_Password_In_LogIn_Page
    cmp [clickPosY],63
    jb check_Click_Password_In_LogIn_Page
    cmp [clickPosY],75
    ja check_Click_Password_In_LogIn_Page
    mov [LogInInfoClickUserPass],1 
	jmp @@exit

	;Password Button in Log In Page
check_Click_Password_In_LogIn_Page:
    cmp [clickPosX],296
    jb check_Click_Submit_Button
    cmp [clickPosX],428
    ja check_Click_Submit_Button
    cmp [clickPosY],91
    jb check_Click_Submit_Button
    cmp [clickPosY],102
    ja check_Click_Submit_Button
    mov [LogInInfoClickUserPass],2 
	
	;check Click Submit Button
check_Click_Submit_Button:
    cmp [clickPosX],250
    jb @@exit
    cmp [clickPosX],388
    ja @@exit
    cmp [clickPosY],137
    jb @@exit
    cmp [clickPosY],153
    ja @@exit
	mov [SubmitBTNClick], 1   ;Submit button Click 
	
	
@@exit:
    ret
endp CheckClickInLogInPage

;מטרת: להדפיס ולהכניס כל תו שקלט מהמקלדת
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מוציא כלום


proc WriteNameInScreen
;User Name
loopWriteUserName:
	cmp [LogInInfoClickUserPass], 1
	jne	Check_Click_Password
	
	xor si,si
loopWriteName:
	cmp [counterNameLength],8
	je @@ExitUserName
	
	
	mov si,[counterNameLength]
	
	mov ah,1
	int 16h
	jz @@didnt_Click_checkSeconfClickPassword
	xor ah,ah
	int 16h
	mov [nametoWrite + si], al

	inc [counterNameLength]
	
	
	call printStringName
	
@@didnt_Click_checkSeconfClickPassword:
	call CheckClickInLogInPage

	cmp [SubmitBTNClick],1
	je @@ExitPassword
	
	cmp [LogInInfoClickUserPass],2
	jne loopWriteName
	jmp Check_Click_Password

@@ExitUserName:
	mov [LogInInfoClickUserPass], 0
	ret
	
	
;Password
Check_Click_Password:
	call printStringPassword
	cmp [LogInInfoClickUserPass], 2
	jne	@@exit
	
	xor si,si
	
	
loopWritepassword:
	cmp [counterPasswordLength],8
	je @@ExitPassword
	
	mov si,[counterPasswordLength]
	
	mov ah,1
	int 16h
	jz @@didnt_Click_checkSeconfClickUserName
	xor ah,ah
	int 16h
	mov [passwordtoWrite + si], al
	
	inc [counterPasswordLength]
	
	call printStringPassword


@@didnt_Click_checkSeconfClickUserName:
	call CheckClickInLogInPage

	cmp [SubmitBTNClick],1
	je @@ExitPassword
	
	cmp [LogInInfoClickUserPass],1
	jne loopWritepassword
	jmp loopWriteUserName


@@ExitPassword:
	mov [LogInInfoClickUserPass],0
	
@@exit:
	ret
endp WriteNameInScreen


;מטרת: לבדוק אם איפה לחץ אם זה בREGISTER PAGE
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם לחץ אזי יכנס לRegisterLogInPage 2

proc CheckClickRegisterPage
	call Click_Pos
	
	cmp [GotClick], 1
	jne @@exit
	
	
	;Register Page
check_Click_Register_Page:
    cmp [clickPosX],374
    jb @@exit
    cmp [clickPosX],486
    ja @@exit
    cmp [clickPosY],167
    jb @@exit
    cmp [clickPosY],178
    ja @@exit
	mov [RegisterLogInPage],2  ;Register Page
	

@@exit:
	ret
	
endp CheckClickRegisterPage

;מטרת: לבדוק אם איפה לחץ אם זה בLOGIN PAGE
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם לחץ אזי יכנס לRegisterLogInPage 1


proc CheckClickLogInPage
	call Click_Pos
	
	cmp [GotClick], 1
	jne @@exit
	
	
	;Log In Page
check_Click_LogIn_Page:
    cmp [clickPosX],412
    jb @@exit
    cmp [clickPosX],480
    ja @@exit
    cmp [clickPosY],171
    jb @@exit
    cmp [clickPosY],182
    ja @@exit
	mov [RegisterLogInPage],1  ;Log In Page
	

@@exit:
	ret


endp CheckClickLogInPage


;מטרת: להכניס למשתנה תו ובודקת שהקובץ לא נגמר
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס למשתנה תו


proc ReadTavFromLogInFile
	;Open File
    mov al,2
    mov dx,offset LogInFile
    mov ah,3dh
    int 21h
	mov [fhandle],ax
	
    ;position from start
    mov al,0h
    mov bx,[fhandle]
    mov ah,42h
    mov cx, 0
    mov dx, [LengthCall]
    int 21h
	
	;read from file
	mov ah, 3fh
	mov bx,[fhandle]
	mov cx,1
	lea dx,[tavFromLogInFile]
	int 21h
	
CheckIfEnd:
	cmp ax, 0
	jne @@Close
	mov [EOF], 1

@@Close:
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h
	
	ret
endp ReadTavFromLogInFile

;מטרת: מכניס את השם והסיסמה והנקודות למשתנה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס למשתנה את השם והסיסמה

proc putTavinUser

	call ReadTavFromLogInFile
	cmp [EOF] ,1
	je @@Exit1
	cmp [tavFromLogInFile], '!'
	je @@PutUserName
	jmp @@Exit

@@Exit1:
	ret
	
@@PutUserName:
	cmp [EOF] ,1
	je @@Exit
	inc [LengthCall]
	call ReadTavFromLogInFile
	cmp [tavFromLogInFile], '$'
	je @@PutPassword
	mov bx, [UserNameLength]
	mov al,[tavFromLogInFile]
	mov [UserName + bx],al
	inc [UserNameLength]
	jmp @@PutUserName
	
@@PutPassword:
	cmp [EOF] ,1
	je @@Exit
	inc [LengthCall]
	call ReadTavFromLogInFile	
	cmp [tavFromLogInFile], '$'
	je @@PutMaxScore
	mov bx, [PasswordLength]
	mov al,[tavFromLogInFile]
	mov [Password + bx],al
	inc [PasswordLength]
	jmp @@PutPassword

@@PutMaxScore:
	cmp [EOF] ,1
	je @@Exit
	inc [LengthCall]
	call ReadTavFromLogInFile	
	xor ax,ax
	mov al, '!';[newLine]
	cmp [tavFromLogInFile], al
	je @@Exit
	mov bx,[lengthScore]
	mov al,[tavFromLogInFile]
	sub al,'0'
	mov [maxScoreSort + bx],al
	dec [lengthScore]
	jmp @@PutMaxScore

@@Exit:
	ret
endp putTavinUser

;מטרת: בודק אם השם והסיסמה נכונים
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס למשתנה PassAndUSerExist 1מ ואם לא 2


proc CheckIfUserAndPassTrue
CheckUserLengthEqual:
	mov ax, [counterNameLength]
	cmp ax, [UserNameLength]
	je CheckPassLengthEqual
	jmp @@Exit
	
CheckPassLengthEqual:
	mov ax, [counterPasswordLength]
	cmp ax, [PasswordLength]
	je CheckUser
	jmp @@Exit

CheckUser:
	xor si,si
	mov cx, [UserNameLength]
CheckUserCorrect:
	mov al,[UserName + si]
	cmp al, [nametoWrite + si]
	jne @@Exit
	inc si
	inc [CorrectTavInUser]
	
	mov bx, [UserNameLength]
	cmp bx, [CorrectTavInUser]
	je CheckPass
	loop CheckUserCorrect

CheckPass:
	xor si,si
	mov cx, [PasswordLength]
CheckPasswordCorrect:
	mov al,[Password + si]
	cmp al, [passwordtoWrite + si]
	jne @@Exit
	inc si
	inc [CorrectTavInPass]

	mov bx, [PasswordLength]
	cmp bx, [CorrectTavInPass]
	je @@CorrectPassAndUser
	loop CheckPasswordCorrect

@@CorrectPassAndUser:	
	mov [PassAndUSerExist], 1   ;Correct
	ret
	
@@Exit:
	mov [PassAndUSerExist], 2 ;Not Correct
	ret
endp CheckIfUserAndPassTrue

;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום
proc NotCorrectLogInPrintPic
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
     ;BMP Option Picture
    mov dx, offset NotCorrectLogInPic
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPic 
    jmp @@exitError
    
@@printPic:
    ret
    
@@exitError:
    mov dx, offset BmpFileErrorMsg
    mov ah,9
    int 21h
    
    ret
endp NotCorrectLogInPrintPic

;proc SortPassUserId
;	mov [informationFromUserPassId], 1
;	xor si,si
;	xor bx,bx
;	jmp sortFileInformation
;	
;informationToUserPassId:
;	inc [informationFromUserPassId]
;	
;	cmp[informationFromUserPassId], 1   ;User
;	je putInformationInUser	
;	
;	cmp[informationFromUserPassId], 2  ;Pass
;	je putInformationInPassWord	
;	
;	cmp[informationFromUserPassId], 3  ;Id
;	je putInformationInId;
	
;	jmp sortFileInformation;

;putInformationInUser:
;	mov bx, [UserNameLength];
;	mov al ,[UserPassIdfromFile + si]
;	mov [UserName], al
;	inc [informationFromUserPassId]
;	inc [UserNameLength]
;	inc si;
;	jmp sortFileInformation
;
;putInformationInPassWord:
;	mov bx, [PasswordLength]
;	mov al ,[UserPassIdfromFile + si]
;	mov [Password], al
;	inc [informationFromUserPassId];
;	inc [PasswordLength]
;	inc si
;	jmp sortFileInformation

;putInformationInId:
;	mov bx,[IdLength]
	;mov al ,[UserPassIdfromFile + si]
	;mov [Id + bx], al
	;inc [informationFromUserPassId]
	;inc [IdLength]
	;inc si
	;jmp sortFileInformation
	
	

	
;sortFileInformation:
	;cmp [UserPassIdfromFile + si], '$'  ;End Of String(Pass/User)
	;je informationToUserPassId
	
	;cmp [UserPassIdfromFile + si], '!'  ;Next User
;	je NextUser
;	
;	
;	jmp sortFileInformation
;
;NextUser:

;endp SortPassUserId

;שם פעולה: PrintRegisterPage
;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום
proc PrintRegisterPage
    ;BMP Option Picture
    mov dx, offset RegisterPagePic
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne printPicHelp 
    jmp ErrorExit
    
printPicHelp:
    ret
    
ErrorExit:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
    ret

endp PrintRegisterPage


;שם פעולה: PrintnoWritePage
;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום

proc PrintnoWritePage
	; Head mouse pointer
    mov ax,2
    int 33h 
	
    ;BMP Option Picture
    mov dx, offset noWriteInPassUser
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPicHelp 
    jmp @@ErrorExit
    
@@printPicHelp:
    ret
    
@@ErrorExit:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
    ret

endp PrintnoWritePage

;מטרת: מדפיס טקסט
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום


proc printStringName
    ; Head mouse pointer
    mov ax,2
    int 33h 

	xor cx,cx
	mov al, 1
	mov bh, 0
	mov bl, 11111111b
	mov cx, [counterNameLength]
	mov dl, 19
	mov dh, 8
	push ds
	pop es
	mov bp, offset nametoWrite
	mov ah, 13h
	int 10h

; Show mouse pointer
    mov ax,1
    int 33h 

	ret
endp printStringName

;מטרת: מדפיס טקסט
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום


proc printStringPassword
    ; Head mouse pointer
    mov ax,2
    int 33h 

	mov al, 1
	mov bh, 0
	mov bl, 11111111b
	mov cx, [counterPasswordLength]
	mov dl, 19
	mov dh, 11
	push ds
	pop es
	mov bp, offset passwordtoWrite
	mov ah, 13h
	int 10h

; Show mouse pointer
    mov ax,1
    int 33h 
	
	ret
endp printStringPassword


;מטרת: מכניס לקובץ שם וסיסמה 
;טענת כניסה:
;מכניס לרגיסטר את מיקום של השם והסיסמה ואת האורך שלהם
;טענת יציאה:
;לא מקבלת כלום

proc WriteUserPassToFile
    ;Open File
    mov al,2
    mov dx,offset LogInFile
    mov ah,3dh
    int 21h
	mov [fhandle],ax

    ;position from End
    mov al,2h
    mov bx,[fhandle]
    mov ah,42h
    mov cx, 0
    mov dx, 0
    int 21h
	
	;Write to file ! 
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset ExclamationMark
    mov cx,1
    int 21h
    
    ;Write to file the user name
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset nametoWrite
    mov cx,[counterNameLength]
    int 21h
    
	;Write to file dollar $
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset dollarWrite
    mov cx,1
    int 21h
	
	;Write to file Password
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset passwordtoWrite
    mov cx,[counterPasswordLength]
    int 21h
	
	
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h

@@exit_Not_Above:
	ret


endp WriteUserPassToFile


;מטרת: מכניס לקובץ הנקודות
;טענת כניסה:
;מכניס לרגיסטר את מיקום של הנקודות
;טענת יציאה:
;לא מקבלת כלום

proc PutScoreInFile
	cmp [RegisterLogInPage], 2
	jne @@Exit
	
    ;Open File
    mov al,2
    mov dx,offset LogInFile
    mov ah,3dh
    int 21h
	mov [fhandle],ax

    ;position from End
    mov al,2h
    mov bx,[fhandle]
    mov ah,42h
    mov cx, 0
    mov dx, 0
    int 21h
	
	;Write to file dollar $
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset dollarWrite
    mov cx,1
    int 21h
	
	;Write to file Max Score
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset WriteToScoreFile
    mov cx,5
    int 21h

	;Write to file New Line
	;xor dx,dx
    ;mov ah,40h
    ;mov bx,[fhandle]
    ;mov dx,offset newLine
    ;mov cx,2
    ;int 21h
	
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h

@@Exit:
	ret
endp PutScoreInFile


;מטרת: בודק אם לא כתב כלום
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מחזירה dontTypeAnyThing 1

proc CheckIfUserAndPassCorrect
	cmp [nametoWrite],''
	je dontTypeAnyThingTryAgain
	
	cmp [passwordtoWrite],''
	je dontTypeAnyThingTryAgain
	jmp @@exit
	
dontTypeAnyThingTryAgain:
	mov [dontTypeAnyThing],1
	
@@exit:
	ret
endp CheckIfUserAndPassCorrect




;מטרת: מוסיפה כל הזמן ובודקת אם עבר את הזמן ומוסיפה לאחד אחר אם עבר 24 שעות 
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם עבר 24 שעות מחזירה YouOut24HPass 1


proc inctimer
	inc [SecondsTime]
	cmp [SecondsTime],60
	jb @@FinishAdding
	
	mov [SecondsTime],0
	inc [MinutesTimes]
	cmp [MinutesTimes],60
	jb @@FinishAdding
	
	inc [hoursTime]
	mov [SecondsTime],0
	mov [MinutesTimes],0
	
	cmp [hoursTime],24
	jb @@FinishAdding

@@Pass24Hours:
	mov dx,offset Pass24H
	mov ah,9h
	int 21h
	
	mov [YouOut24HPass], 1
	
@@FinishAdding:
	ret
endp inctimer


;מ\טרת: מעדכנת את הטיימר הגדול
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מוציאה כלום

proc updatetimerUntingEndGame
	xor bx,bx
	mov bl,[hoursTime]
	push bx
	push offset TimerLook
	call updateparttime
	mov bl,[MinutesTimes]
	push bx
	mov si,offset TimerLook
	add si,3
	push si
	call updateparttime
	mov bl,[SecondsTime]
	push bx
	mov si,offset TimerLook
	add si,6
	push si
	call updateparttime
	;do the same for milis here if wanted: timestr+9 and +10
	ret
endp updatetimerUntingEndGame

;מטרת: מעדכנת את הטיימר הקטן
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מוציאה כלום


proc updatetimer
	xor bx,bx
	mov bl,[TimeBackTo0]
	push bx
	push offset TimerLookBack
	call updateparttime
	ret
endp updatetimer

;מטרת: עוזרת לעדכנת את הטיימר הקטן
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מוציאה כלום

proc updateparttime   ;bp+4:offset of first place in string,bp+6;value
	push bp
	mov bp,sp
	mov si,[bp+4]
	mov bx,[bp+6]
	cmp bx,10
	jb @@reg
	mov ax,bx
	mov bh,10
	div bh
	mov bh,al
	mov bl,ah
	@@reg:
	add bl,'0'
	add bh,'0'
	mov [si],bh
	mov [si+1],bl
	xor bx,bx
	pop bp
	ret 4
endp updateparttime

;מטרת: בודקת אם הזמן נגמר
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם הזמן נגמר אזי מכניס לEndGameTime 1

proc CheckEndGameZero
	cmp [TimeBackTo0],0
	jne @@exit
	
	mov [EndGameTime], 1

@@exit:
	ret
endp CheckEndGameZero

;מטרת:  מחסירה את הטיימר
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מחסיר ב 1 את TimeBackTo0

proc DecToTimer
	mov dh, 50
	mov dl, 50
	mov bh, 0
	mov ah, 2
	int 10h
	
    dec [TimeBackTo0]

@@exit:
	ret
endp DecToTimer

;מטרת:  מוסיפה את הנקודות
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מוסיפה את AddScoreSuc לScore

proc AddScore
	add [Score], AddScoreSuc
	
	ret
endp AddScore

;מטרת:  בודקת אם ניצח
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם נצח אזי מכניסה 1 לVictoryGame
proc CheckFinishGame
	cmp [Score], EndWinGameScore
	jna @@NotFinish
	
	mov [VictoryGame], 1

@@NotFinish:
	ret
endp CheckFinishGame


;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום

proc HelpPage1
    ;BMP Option Picture
    mov dx, offset HelpInfoPicture
    mov [BmpLeft],128
    mov [BmpTop],18
    mov [BmpColSize], 189
    mov [BmpRowSize] ,178
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPicHelp 
    jmp @@ErrorExit
    
@@printPicHelp:
    ret
    
@@ErrorExit:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
    ret

endp HelpPage1


;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום

proc PrintTableScorePic
	; Show mouse pointer
    mov ax,2
    int 33h 
	
    ;BMP Option Picture
    mov dx, offset TableScorepicture
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPicHelp 
    jmp @@ErrorExit
    
@@printPicHelp:
    ret
    
@@ErrorExit:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
    ret

endp PrintTableScorePic


;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום


proc IconGamePrintPic
    ;BMP Option Picture
    mov dx, offset IconGamePic
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne printIconPic 
    jmp @@err
    
printIconPic:
    ret
    
@@err:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
	
    ret
endp IconGamePrintPic


;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום

proc GamePic
    ;BMP Option Picture
    mov dx, offset GamePhoto
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPicHelp 
    jmp @@ErrorExit
    
@@printPicHelp:
    ret
    
@@ErrorExit:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
    ret
endp GamePic


;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום

proc EndGame
    ;BMP Option Picture
    mov dx, offset EndGamePic
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPicHelp 
    jmp @@ErrorExit
    
@@printPicHelp:
    ret
    
@@ErrorExit:
    mov dx, offset BmpFileErrorMsgHelp
    mov ah,9
    int 21h
    ret
endp EndGame


;מטרת: מדפיס תמונה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מקבלת כלום

proc VictoryGameWin
    ;BMP Option Picture
    mov dx, offset VictoryBlind
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPicHelp 
    jmp @@ErrorExit
    
@@printPicHelp:
    ret
    
@@ErrorExit:
    ;mov dx, offset BmpFileErrorMsgHelp
    ;mov ah,9
    ;int 21h
    ret
endp VictoryGameWin


;מטרת: בודקת אם לחץ על END GAME  או כל RETURN 
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מחזירה ReturnBtn 1 אם נילחץ על RETURN או EndGameBtn 1 אם נלחץ END

proc EndGameButtons
CheckClickExitOrRet:
	call Click_Pos
	
	cmp [GotClick],1
    jz Check_Click_End_Game_Button
	jmp CheckClickExitOrRet

Check_Click_End_Game_Button:
	cmp [clickPosX],272
	jb Check_Click_Return_Game_Button
	cmp [clickPosX],306    
	ja Check_Click_Return_Game_Button
	cmp [clickPosY],138
	jb Check_Click_Return_Game_Button
	cmp [clickPosY],154 
	ja Check_Click_Return_Game_Button

	mov [EndGameBtn],1
	jmp @@Exit


Check_Click_Return_Game_Button:
	cmp [clickPosX],342
	jb @@Exit
	cmp [clickPosX],374  
	ja @@Exit
	cmp [clickPosY],138
	jb @@Exit
	cmp [clickPosY],154
	ja @@Exit

	mov [ReturnBtn],1


@@Exit:
	ret
endp EndGameButtons


;מטרת: מדפיסה את את הצבעים במוקומות מסויימים בצבעים שונים
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניסה לChangeColor את מספר הצבע השונה לrndNumColor1 את הצבע שהוא שונה


proc PrintColorAndChangeColor
	randomColors 1,4
	mov [ChangeColor],al  ;3 third
	
	randomColors 1,255
	mov [rndNumColor1],al ;2 blue


;Check the Color i need to Change
First_Change_Color:	
	cmp [ChangeColor],1
	je First_square_change_Color

Second_Change_Color:
	cmp [ChangeColor],2
	je Second_square_change_Color

Third_Change_Color:
	cmp [ChangeColor],3
	je Third_square_change_Color

Forth_Change_Color:
	cmp [ChangeColor],4
	je jumpToForth_square_change_Color


jumpToForth_square_change_Color:
	jmp Forth_square_change_Color

	;Change color for specific square
First_square_change_Color:
	randomColors 1,255
	mov [rndNumColor2],al
	
	cmp al,[rndNumColor1]
	je First_square_change_Color
	
	mov [squareSize],60
	mov [color],al
	mov [Xp],82
	mov [Yp],56
	call DrawSquare
	jmp Second_square_onRightUp	
	
Second_square_change_Color:
	randomColors 1,255
	mov [rndNumColor2],al
	
	cmp al,[rndNumColor1]
	je Second_square_change_Color
	
	mov [squareSize],60
	mov [color],al
	mov [Xp],170
	mov [Yp],56
	call DrawSquare
	jmp First_squareLeftUp
	
	
Third_square_change_Color:
	randomColors 1,255
	mov [rndNumColor2],al  ;5 yellow
	
	cmp al,[rndNumColor1]  ;yellow(5) != blue(2)
	je Third_square_change_Color
	
	mov [squareSize],60
	mov [color],al
	mov [Xp],82
	mov [Yp],130
	call DrawSquare
	jmp First_squareLeftUp
	
	
Forth_square_change_Color:
	randomColors 1,255
	mov [rndNumColor2],al
	
	cmp al,[rndNumColor1]
	je Forth_square_change_Color
	
	mov [squareSize],60
	mov [color],al
	mov [Xp],170
	mov [Yp],130
	call DrawSquare
	jmp First_squareLeftUp
	
	

;Print Other Colors Square	
First_squareLeftUp:
	mov al,[rndNumColor1]
	mov [squareSize],60
	mov [color],al
	mov [Xp],82
	mov [Yp],56
	call DrawSquare
	
	cmp [ChangeColor],2
	jne Second_square_onRightUp
	jmp Third_square_LeftDown
	
Second_square_onRightUp:
	mov al,[rndNumColor1]
	mov [squareSize],60
	mov [color],al
	mov [Xp],170
	mov [Yp],56
	call DrawSquare
	
	cmp [ChangeColor],3
	jne Third_square_LeftDown
	jmp Forth_square_onRightDown
	
	
Third_square_LeftDown:
	mov al,[rndNumColor1]
	mov [squareSize],60
	mov [color],al
	mov [Xp],82
	mov [Yp],130
	call DrawSquare
	
	cmp [ChangeColor],4
	jne Forth_square_onRightDown
	ret
	
Forth_square_onRightDown:
	mov al,[rndNumColor1]
	mov [squareSize],60
	mov [color],al
	mov [Xp],170
	mov [Yp],130
	call DrawSquare
	
	ret
endp PrintColorAndChangeColor


;מטרת: בודק אם לחת על הצבע הנכון
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם בחר בצבע הנכון יכניס את 1 לYouSucceeded ואם לא אז 1 לYouLose

proc Check_Click_Different_Color
	call Click_Pos
	
	cmp [GotClick],1
    jnz jumpToRet_Exit
	jmp Check_Click_First_square_LeftUp
	
jumpToRet_Exit:
	jmp @@Ret_Exit

Check_Click_First_square_LeftUp:
	cmp [clickPosX],164  
	jb Check_Click_Second_square_RightUp
	cmp [clickPosX],284    
	ja Check_Click_Second_square_RightUp
	cmp [clickPosY],65
	jb Check_Click_Second_square_RightUp
	cmp [clickPosY],125 
	ja Check_Click_Second_square_RightUp
	
	cmp [ChangeColor],1
	jne @@JumpToYouLose
	mov [YouSucceeded],1
	jmp @@Ret_Exit

@@JumpToYouLose:
	jmp @@You_Lose


Check_Click_Second_square_RightUp:
	cmp [clickPosX],340
	jb Check_Click_Third_square_LeftDown
	cmp [clickPosX],460
	ja Check_Click_Third_square_LeftDown
	cmp [clickPosY],65
	jb Check_Click_Third_square_LeftDown
	cmp [clickPosY],125
	ja Check_Click_Third_square_LeftDown
	
	cmp [ChangeColor],2
	jne @@You_Lose
	mov [YouSucceeded],1
	jmp @@Ret_Exit

Check_Click_Third_square_LeftDown:
	cmp [clickPosX],164
	jb Check_Click_Forth_square_RightDown
	cmp [clickPosX],284
	ja Check_Click_Forth_square_RightDown
	cmp [clickPosY],130
	jb Check_Click_Forth_square_RightDown
	cmp [clickPosY],190
	ja Check_Click_Forth_square_RightDown
	
	cmp [ChangeColor],3
	jne @@You_Lose
	mov [YouSucceeded],1
	jmp @@Ret_Exit

Check_Click_Forth_square_RightDown:
	cmp [clickPosX],340
	jb @@Ret_Exit
	cmp [clickPosX],460
	ja @@Ret_Exit
	cmp [clickPosY],130
	jb @@Ret_Exit
	cmp [clickPosY],190
	ja @@Ret_Exit
	
	cmp [ChangeColor],4
	jne @@You_Lose
	mov [YouSucceeded],1


@@Ret_Exit:
	ret
	
@@You_Lose:
	mov [YouLose],1
	ret

endp Check_Click_Different_Color

;מטרת: קורא את הנקודות מקובץ
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס את הנקודות לMAXSCORE

proc readMaxScoreFile
    ;Open File
    mov al,2
    mov dx,offset FileNameMaxScore
    mov ah,3dh
    int 21h
	mov [fhandle],ax
	
	;position from start
    ;mov al,0h
    ;mov bx,[fhandle]
    ;mov ah,42h
    ;mov cx, 0
    ;mov dx, [EndOfFile]
    ;int 21h
	
	;read from file
	mov ah, 3fh
	mov bx,[fhandle]
	mov cx,5
	lea dx,[maxScore]
	int 21h
	
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h
	
	ret
endp readMaxScoreFile



;מטרת: בודק אם הנקודות יותר גדולים והמקס נקודות ואם כן יכניס אותם לקובץ
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס את הנקודות לMAXSCORE


proc CheckMaxScore
	mov ax,[Score]
	cmp ax,[maxScore]
	jna @@exit_Not_Above
	mov [maxScore],ax

@@PutMaxScoreinFile:
    ;Open File
    mov al,2
    mov dx,offset FileNameMaxScore
    mov ah,3dh
    int 21h
	mov [fhandle],ax
   
    ;position from start
    ;mov al,0h
    ;mov bx,[fhandle]
    ;mov ah,42h
    ;mov cx, 0
    ;mov dx, [EndOfFile]
    ;int 21h
   
    ;Write to file
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset maxScore
    mov cx,5
    int 21h
    
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h

@@exit_Not_Above:
	ret
endp CheckMaxScore



; Description  : get RND between any bl and bh includs (max 0 -255)
; Input        : 1. Bl = min (from 0) , BH , Max (till 255)
; 			     2. RndCurrentPos a  word variable,   help to get good rnd number
; 				 	Declre it at DATASEG :  RndCurrentPos dw ,0
;				 3. EndOfCsLbl: is label at the end of the program one line above END start		
; Output:        Al - rnd num from bl to bh  (example 50 - 150)
; More Info:
; 	Bl must be less than Bh 
; 	in order to get good random value again and agin the Code segment size should be 
; 	at least the number of times the procedure called at the same second ... 
; 	for example - if you call to this proc 50 times at the same second  - 
; 	Make sure the cs size is 50 bytes or more 
; 	(if not, make it to be more) 
proc RandomByCs
    push es
	push si
	push di
	
	mov ax, 40h
	mov	es, ax
	
	sub bh,bl  ; we will make rnd number between 0 to the delta between bl and bh
			   ; Now bh holds only the delta
	cmp bh,0
	jz @@ExitP
 
	mov di, [word RndCurrentPos]
	call MakeMask ; will put in si the right mask according the delta (bh) (example for 28 will put 31)
	
RandLoop: ;  generate random number 
	mov ax, [es:06ch] ; read timer counter
	mov ah, [byte cs:di] ; read one byte from memory (from semi random byte at cs)
	xor al, ah ; xor memory and counter
	
	; Now inc di in order to get a different number next time
	inc di
	cmp di,(EndOfCsLbl - start - 1)
	jb @@Continue
	mov di, offset start
@@Continue:
	mov [word RndCurrentPos], di
	
	and ax, si ; filter result between 0 and si (the mask)
	cmp al,bh    ;do again if  above the delta
	ja RandLoop
	
	add al,bl  ; add the lower limit to the rnd num
		 
@@ExitP:	
	pop di
	pop si
	pop es
	ret
endp RandomByCs

; make mask acording to bh size 
; output Si = mask put 1 in all bh range
; example  if bh 4 or 5 or 6 or 7 si will be 7
; 		   if Bh 64 till 127 si will be 127
Proc MakeMask    
    push bx

	mov si,1
    
@@again:
	shr bh,1
	cmp bh,0
	jz @@EndProc
	
	shl si,1 ; add 1 to si at right
	inc si
	
	jmp @@again
	
@@EndProc:
    pop bx
	ret
endp  MakeMask


proc drawSquare
	push cx

    mov al,[Color]
    mov dx,[Yp]
	mov si,[SquareSize]  ;add to Y end Posesion
	mov [squareYpEnd],dx
	add [squareYpEnd],si
setCxSi:
	mov si,[SquareSize]  ; line Length
    mov cx,[Xp]

DrawLine:
    cmp si,0
    jz SecLinePix  ;finish the line
     
    mov ah,0ch  
    int 10h    ; put pixel
     
    
    inc cx
    dec si
    jmp DrawLine
    
SecLinePix:
	inc dx
	cmp dx,[squareYpEnd]
	jne setCxSi
	
	
	pop cx
    ret
endp drawSquare

;מטרת: מאפס את הDATA
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס לWhichTextInHelpP SoundHelpPage GotClick clickPosX clickPosY YouSucceeded YouLose ExitTextPage 0

proc ResetButtonsData
	mov [WhichTextInHelpP], 0
	mov [SoundHelpPage], 0
	mov [GotClick], 0
	mov [clickPosY], 0
	mov [clickPosX],0
	mov [YouSucceeded],0
	mov [YouLose],0
	mov [ExitTextPage],0
	
	ret
endp ResetButtonsData


;מטרת: בודק אם נילחץ על השמע
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מכניס לקובץ 1 ואז אחרי 2 שניות מחזיר 0

proc HelpPageSoundBtn
    ;check if click
sound_on_in_Help_Page:
    cmp [SoundHelpPage],1
    jnz @@exit
    
    
sound:
    ;Open File
    mov al,2
    mov dx,offset fileNameSound
    mov ah,3dh
    int 21h
    mov [fhandle],ax
    
    ;Write to file
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset datatowriteOn
    mov cx,1
    int 21h
    
    ;position from start
    mov al,0h
    mov bx,[fhandle]
    mov ah,42h
    mov cx, 0
    mov dx, 0
    int 21h
    
	
    Delay 5h
    
    ;Write to file
    mov ah,40h
    mov bx,[fhandle]
    mov dx,offset datatowriteOff
    mov cx,1
    int 21h
    
    
    ;close File
    mov ah,3eh
    mov bx,[fhandle]
    int 21h
    
    
    

@@exit:
    ret

endp HelpPageSoundBtn


;מטרת: בודק אם נילחץ על השמע  או כל EXIT או הטקסטים
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם על הEXIT מכניס 0 לWhichPage אם על השמע מכניס 1 SoundHelpPage ואם על הטקסט על כל טקסט מכניס תמספר שלו

proc HelpPageAnyButton
    ;check if click
if_Click_Exit_Help_P:
    call Click_Pos
    
    cmp [GotClick],1
    jnz if_Click_Exit_Help_P
    
;Exit Button in Help Page
check_Click_Exit_In_Help_Page:
    cmp [clickPosX],294 ;294
    jb check_Click_sound_In_Help_Page
    cmp [clickPosX],335 ;335
    ja check_Click_sound_In_Help_Page
    cmp [clickPosY],158 ;158
    jb check_Click_sound_In_Help_Page
    cmp [clickPosY],184 ;184
    ja check_Click_sound_In_Help_Page
    mov [WhichPage],0 ;to menu page
    ret
    
    ;sound Button in Help Page
check_Click_sound_In_Help_Page:
    cmp [clickPosX],562 ;281
    jb check_Click_WhatToPlay?_In_Help_Page
    cmp [clickPosX],600 ;309
    ja check_Click_WhatToPlay?_In_Help_Page
    cmp [clickPosY],32 ;32
    jb check_Click_WhatToPlay?_In_Help_Page
    cmp [clickPosY],47 ;47
    ja check_Click_WhatToPlay?_In_Help_Page
    mov [SoundHelpPage],1 ;on-1, off-0
    ret
    
    
;text 1 in Help Page
check_Click_WhatToPlay?_In_Help_Page:
    cmp [clickPosX],448
    jb check_Click_WhatToDoWithPoint?_In_Help_Page
    cmp [clickPosX],612
    ja check_Click_WhatToDoWithPoint?_In_Help_Page
    cmp [clickPosY],108
    jb check_Click_WhatToDoWithPoint?_In_Help_Page
    cmp [clickPosY],120
    ja check_Click_WhatToDoWithPoint?_In_Help_Page
    mov [WhichTextInHelpP],1 ;the first text
    ret
    
;text 2 in Help Page
check_Click_WhatToDoWithPoint?_In_Help_Page:
    cmp [clickPosX],396
    jb check_Click_HowToChangeToCoins?_In_Help_Page
    cmp [clickPosX],610
    ja check_Click_HowToChangeToCoins?_In_Help_Page
    cmp [clickPosY],124
    jb check_Click_HowToChangeToCoins?_In_Help_Page
    cmp [clickPosY],137
    ja check_Click_HowToChangeToCoins?_In_Help_Page
    mov [WhichTextInHelpP],2 ;the second text
    ret
    
;text 3 in Help Page
check_Click_HowToChangeToCoins?_In_Help_Page:
    cmp [clickPosX],430
    jb Not_click_In_Help_Page
    cmp [clickPosX],610
    ja Not_click_In_Help_Page
    cmp [clickPosY],140
    jb Not_click_In_Help_Page
    cmp [clickPosY],152
    ja Not_click_In_Help_Page
    mov [WhichTextInHelpP],3 ;the third text
    ret

Not_click_In_Help_Page:
    jmp if_Click_Exit_Help_P
    
@@exit:
    ret
endp HelpPageAnyButton

;מטרת: בודק אם נילחץ על EXIT
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם על הEXIT מכניס 0 לExitTextPage

proc TextExitP
    ;check if click
if_Click_Exit_Text_P:
    call Click_Pos
    
    cmp [GotClick],1
    jz check_Click_Exit_In_Text_Page
    ret
    
    ;jnz if_Click_Exit_Text_P
    
;Exit Button in Help Page
check_Click_Exit_In_Text_Page:
    cmp [clickPosX],294 ;294
    jb Not_click_In_Text_Page
    cmp [clickPosX],335 ;335
    ja Not_click_In_Text_Page
    cmp [clickPosY],158 ;158
    jb Not_click_In_Text_Page
    cmp [clickPosY],184 ;184
    ja Not_click_In_Text_Page
	mov [ExitTextPage],1
	call HelpPage1
    ret

Not_click_In_Text_Page:
    ret
;    jmp if_Click_Exit_Text_P
    
    
endp TextExitP

;מטרת: בודק אם נילחץ על EXIT
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;אם על הEXIT מכניס 0 לWhichTextInHelpP

proc HelpPageExitButton
    ;check if click
Click_Text_in_Help_Page:
    call Click_Pos
    
    cmp [GotClick],1
    jnz Not_click__Exit_In_Help_Page
    
;Exit Button in Help Page
@@check_Click_Exit_In_Help_Page:
    cmp [clickPosX],294 ;294
    jb Not_click__Exit_In_Help_Page
    cmp [clickPosX],335 ;335
    ja Not_click__Exit_In_Help_Page
    cmp [clickPosY],158 ;158
    jb Not_click__Exit_In_Help_Page
    cmp [clickPosY],184 ;184
    ja Not_click__Exit_In_Help_Page
    mov [WhichTextInHelpP],0 ;to menu page
    ret


Not_click__Exit_In_Help_Page:
    jmp Click_Text_in_Help_Page


endp HelpPageExitButton

;מטרת: בודק אם נילחץ על איזה טקסט ומדפיס אותו
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום

proc WhatTextClick

noneText:
    cmp [WhichTextInHelpP],0
    jne firstText
    call NoneTextHelpPage
    ret

firstText:
    cmp [WhichTextInHelpP],1
    jne secondText
    call Text1HelpPage
    ret
    
secondText:
    cmp [WhichTextInHelpP],2
    jne thirdText
    call Text2HelpPage
    ret
    
thirdText:
    cmp [WhichTextInHelpP],3
    jne @@exit
    call Text3HelpPage
    ret
	
@@exit:
    ret

endp WhatTextClick

;מטרת: סתם טקסט שמדפיס את הHELP PAGE
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום

;None Text
proc NoneTextHelpPage
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
    call HelpPage1
    
    ret

endp NoneTextHelpPage

;מטרת: מדפיס טקסט 
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום

;text 1
proc Text1HelpPage
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
     ;BMP Option Picture
    mov dx, offset Text1InHelpPage
    mov [BmpLeft],128
    mov [BmpTop],18
    mov [BmpColSize], 189
    mov [BmpRowSize] ,178
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPic 
    jmp @@exitError
    
@@printPic:
    ret
    
@@exitError:
    mov dx, offset BmpFileErrorMsg
    mov ah,9
    int 21h
    
    ret


endp Text1HelpPage

;מטרת: מדפיס טקסט 
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום
;text 2
proc Text2HelpPage
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
     ;BMP Option Picture
    mov dx, offset Text2InHelpPage
    mov [BmpLeft],128
    mov [BmpTop],18
    mov [BmpColSize], 189
    mov [BmpRowSize] ,178
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPic 
    jmp @@exitError
    
@@printPic:
    ret
    
@@exitError:
    mov dx, offset BmpFileErrorMsg
    mov ah,9
    int 21h
    
    ret
endp Text2HelpPage

;מטרת: מדפיס טקסט 
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום
;text 3
proc Text3HelpPage
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
     ;BMP Option Picture
    mov dx, offset Text3InHelpPage
    mov [BmpLeft],128
    mov [BmpTop],18
    mov [BmpColSize], 189
    mov [BmpRowSize] ,178
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPic 
    jmp @@exitError
    
@@printPic:
    ret
    
@@exitError:
    mov dx, offset BmpFileErrorMsg
    mov ah,9
    int 21h
    
    ret
endp Text3HelpPage


;מטרת: מכניס למצד גרפיקה
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום

proc  SetGraphic
    mov ax,13h   ; 320 X 200 
                 ;Mode 13h is an IBM VGA BIOS mode. It is the specific standard 256-color mode 
    int 10h
    ret
endp    SetGraphic

;מטרת: מאפס את המסך
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום

proc resetScreen
    MOV AH, 06h                         ; Scroll up function
    XOR AL, AL                          ; Clear entire screen
    XOR CX, CX                          ; Upper left corner CH=row, CL=column
    MOV DX, 184FH                       ; lower right corner DH=row, DL=column 
    MOV BH, 0h                          ; black
    INT 10H
endp resetScreen


;מטרת: מדפיס את המסך הMENU
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;לא מחזירה כלום

proc MenuPage
MenuPageGame:
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
     ;BMP Option Picture
    mov dx, offset OptionPicture
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne printPic 
    jmp exitError
    
printPic:
    ret
    
exitError:
    mov dx, offset BmpFileErrorMsg
    mov ah,9
    int 21h
    
    ret
endp MenuPage

;מטרת: מחזיר את המיקום שהוא נלחץ
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מחזיר לGotClick clickPosX clickPosY את המיקומים

proc Click_Pos
;check if click
if_Click_jump:
    xor bx,bx
    mov ax,3
    int 33h
    cmp bx,1
    jz Save_Pos
    cmp bx,2
    jz Save_Pos
	jmp @@exit

Save_Pos:
    mov [GotClick],bx
    mov [clickPosX],cx
    mov [clickPosY],dx
     
@@exit:	 
    ret
endp Click_Pos

;מטרת: בודק איפה לחץ
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מחזיר לWhichPage את המספר שלחץ עליו(לפי המסדר)

proc CheckClickButtons
    ;check if click
if_Click:
    call Click_Pos
    
    cmp [GotClick],1
    jz click_Left
    jmp if_Click
    
click_Left:
;exit Button
check_Click_Exit:   
    cmp [clickPosX],30 ;15
    jb check_Click_Start
    cmp [clickPosX],226 ;113
    ja check_Click_Start
    cmp [clickPosY],156 ;156
    jb check_Click_Start
    cmp [clickPosY],183 ;183
    ja check_Click_Start
    mov [WhichPage],1
    jmp @@exit
    
   
;Start Button
check_Click_Start:
    cmp [clickPosX],30 ;15
    jb check_Click_Help
    cmp [clickPosX],226 ;113
    ja check_Click_Help
    cmp [clickPosY],47 ;47
    jb check_Click_Help
    cmp [clickPosY],74 ;74
    ja check_Click_Help
    mov [WhichPage],2
    jmp @@exit
    
;Help Button
check_Click_Help:
    cmp [clickPosX],30 ;15
    jb check_Click_Table_Score
    cmp [clickPosX],226 ;113
    ja check_Click_Table_Score
    cmp [clickPosY],83 ;83
    jb check_Click_Table_Score
    cmp [clickPosY],110 ;110
    ja check_Click_Table_Score
    mov [WhichPage],3
    jmp @@exit
	
	
;Table Button
check_Click_Table_Score:
    cmp [clickPosX],28
    jb loop_IfNotclick
    cmp [clickPosX],230
    ja loop_IfNotclick
    cmp [clickPosY],119
    jb loop_IfNotclick
    cmp [clickPosY],147
    ja loop_IfNotclick
    mov [WhichPage],4
    jmp @@exit
	
	
loop_IfNotclick:
    jmp if_Click
    
@@exit:
    ret
endp CheckClickButtons


proc LogInPrintPic
    ; Head mouse pointer
    mov ax,2
    int 33h 
    
     ;BMP Option Picture
    mov dx, offset logInPage
    mov [BmpLeft],0
    mov [BmpTop],0
    mov [BmpColSize], 320
    mov [BmpRowSize] ,200
    
    call OpenShowBmp
    cmp [ErrorFile],1
    jne @@printPic 
    jmp @@exitError
    
@@printPic:
    ret
    
@@exitError:
    ret

endp LogInPrintPic

;מטרת: בודק אם לחץ לצאת
;טענת כניסה:
;לא מקבלת כלום
;טענת יציאה:
;מחזיר לWhichPage את 1

proc CheckLeave
    ;check if click
    call Click_Pos
    
    cmp [GotClick],1
    jnz @@return
	
    cmp [clickPosX],12
    jb @@return
    cmp [clickPosX],52
    ja @@return
    cmp [clickPosY],171
    jb @@return
    cmp [clickPosY],196
    ja @@return
    mov [WhichPage],1

@@return:
	ret
endp CheckLeave


proc OpenShowBmp near
    
     
    call OpenBmpFile
    cmp [ErrorFile],1
    je @@ExitProc
    
    call ReadBmpHeader
    
    call ReadBmpPalette
    
    call CopyBmpPalette
    
    call ShowBMP
    
    call CloseBmpFile

@@ExitProc:
    ret
endp OpenShowBmp

 
 
    
; input dx filename to open
proc OpenBmpFile    near                         
    mov ah, 3Dh
    xor al, al
    int 21h
    jc @@ErrorAtOpen
    mov [FileHandle], ax
    jmp @@ExitProc
    
@@ErrorAtOpen:
    mov [ErrorFile], 1
@@ExitProc: 
    ret
endp OpenBmpFile
 
 

proc CloseBmpFile near
    mov ah,3Eh
    mov bx, [FileHandle]
    int 21h
    ret
endp CloseBmpFile




; Read 54 bytes the Header
proc ReadBmpHeader  near                    
    push cx
    push dx
    
    mov ah,3fh
    mov bx, [FileHandle]
    mov cx,54
    mov dx,offset Header
    int 21h
    
    pop dx
    pop cx
    ret
endp ReadBmpHeader



proc ReadBmpPalette near ; Read BMP file color palette, 256 colors * 4 bytes (400h)
                         ; 4 bytes for each color BGR + null)           
    push cx
    push dx
    
    mov ah,3fh
    mov cx,400h
    mov dx,offset Palette
    int 21h
    
    pop dx
    pop cx
    
    ret
endp ReadBmpPalette


; Will move out to screen memory the colors
; video ports are 3C8h for number of first color
; and 3C9h for all rest
proc CopyBmpPalette     near                    
                                        
    push cx
    push dx
    
    mov si,offset Palette
    mov cx,256
    mov dx,3C8h
    mov al,0  ; black first                         
    out dx,al ;3C8h
    inc dx    ;3C9h
CopyNextColor:
    mov al,[si+2]       ; Red               
    shr al,2            ; divide by 4 Max (cos max is 63 and we have here max 255 ) (loosing color resolution).             
    out dx,al                       
    mov al,[si+1]       ; Green.                
    shr al,2            
    out dx,al                           
    mov al,[si]         ; Blue.             
    shr al,2            
    out dx,al                           
    add si,4            ; Point to next color.  (4 bytes for each color BGR + null)             
                                
    loop CopyNextColor
    
    pop dx
    pop cx
    
    ret
endp CopyBmpPalette


proc ShowBMP 
; BMP graphics are saved upside-down.
; Read the graphic line by line (BmpRowSize lines in VGA format),
; displaying the lines from bottom to top.
    push cx
    
    mov ax, 0A000h
    mov es, ax
    
    mov cx,[BmpRowSize]
    
 
    mov ax,[BmpColSize] ; row size must dived by 4 so if it less we must calculate the extra padding bytes
    xor dx,dx
    mov si,4
    div si
    cmp dx,0
    mov bp,0
    jz @@row_ok
    mov bp,4
    sub bp,dx

@@row_ok:   
    mov dx,[BmpLeft]
    
@@NextLine:
    push cx
    push dx
    
    mov di,cx  ; Current Row at the small bmp (each time -1)
    add di,[BmpTop] ; add the Y on entire screen
    
 
    ; next 5 lines  di will be  = cx*320 + dx , point to the correct screen line
    dec di
    mov cx,di
    shl cx,6
    shl di,8
    add di,cx
    add di,dx
     
    ; small Read one line
    mov ah,3fh
    mov cx,[BmpColSize]  
    add cx,bp  ; extra  bytes to each row must be divided by 4
    mov dx,offset ScrLine
    int 21h
    ; Copy one line into video memory
    cld ; Clear direction flag, for movsb
    mov cx,[BmpColSize]  
    mov si,offset ScrLine
    rep movsb ; Copy line to the screen
    
    pop dx
    pop cx
     
    loop @@NextLine
    
    pop cx
    ret
endp ShowBMP


proc ShowAxDecimal
       push ax
	   push bx
	   push cx
	   push dx
		
PositiveAx:
       mov cx,0   ; will count how many time we did push 
       mov bx,10  ; the divider
   
put_mode_to_stack:
       xor dx,dx
       div bx
       add dl,30h
	   ; dl is the current LSB digit 
	   ; we cant push only dl so we push all dx
       push dx    
       inc cx
       cmp ax,9   ; check if it is the last time to div
       jg put_mode_to_stack

	   cmp ax,0
	   jz pop_next  ; jump if ax was totally 0
       add al,30h  
	   mov dl, al    
  	   mov ah, 2h
	   int 21h        ; show first digit MSB
	       
pop_next: 
       pop ax    ; remove all rest LIFO (reverse) (MSB to LSB)
	   mov dl, al
       mov ah, 2h
	   int 21h        ; show all rest digits
	   
       loop pop_next
   
	   pop dx
	   pop cx
	   pop bx
	   pop ax
	   
	   ret
endp ShowAxDecimal
EndOfCsLbl:
END start