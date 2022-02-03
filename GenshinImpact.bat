REM echo on for debugging
@ECHO OFF
REM Set the title of the command prompt
TITLE GenshinImpact Resolution launcher script
REM Clear the screen of previous commands
CLS
goto BatchGotAdmin




REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Permissions
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM Check if the script is being executed with admin priveleges (this is needed to change the process priority of the game later as its ran with admin priveleges as well)
REM ask the user if they want limited performance
REM Credit: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file

:BatchGotAdmin
::-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto Perm_info
) else ( goto gotAdmin )

:Perm_info
	ECHO !!!Permission Error!!!
	ECHO This scrpt needs administrative permission to set the task priority for genshinimpact.exe
	ECHO which for lower end hard where will give a performance boost, and pervent lagging.
	ECHO.
	ECHO To ignor this error Input X (priority for genshinimpact.exe will not be set)
	ECHO To grent permission Input Y, but if denaied the script will exit
	SET /p i=Input: 
	if /i "%i%"=="x" (
		SET "i="
		SET "ignorPiority=ture"
		goto info_NP
	)
	if /i "%i%"=="Y" (
		goto UACPrompt
	)

:UACPrompt
    ECHO Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    SET params= %*
    ECHO UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
	SET "ignorPiority=false"
	goto info





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Information
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

REM NO priority Version
:info_NP
CLS
ECHO Hello traveler!
ECHO.
ECHO The script can do the following things:
ECHO  - Run the game at its lowest graphical preset
ECHO  - Force DirectX11 to be used to render the game
ECHO.
ECHO.
ECHO. 
ECHO Credits:
ECHO  - u/loltheybannedshaman for his work on the reddit thread
ECHO  - Mathieu Squidward for his help with the issues i had
ECHO  - ElectroAegis for being an amazing tester
ECHO  - Rob van der Woude for his bat code checker
ECHO  - The people over at stackoverflow
ECHO  - shirooo39 over at GitHub for his work on the custom resolution part of this script
ECHO  - Little-Karl for the customization
ECHO.
ECHO.
REM Wait for user input
PAUSE
CLS
goto menu_process


REM Elevated info screen
:info
CLS
ECHO Hello traveler!
ECHO.
ECHO The script can do the following things:
ECHO - Run the game at its lowest graphical preset
ECHO - Force DirectX11 to be used to render the game
ECHO - Increase the process priority of the game after 30 seconds of launching the game 
ECHO.
ECHO. 
ECHO Credits:
ECHO  - u/loltheybannedshaman for his work on the reddit thread
ECHO  - Mathieu Squidward for his help with the issues i had
ECHO  - ElectroAegis for being an amazing tester
ECHO  - Rob van der Woude for his bat code checker
ECHO  - The people over at stackoverflow
ECHO  - shirooo39 over at GitHub for his work on the custom resolution part of this script
ECHO  - Little-Karl for the customization
ECHO.
ECHO.
PAUSE
CLS
goto menu_process





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM First Run Check
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

:menu_process
REM Setup the %gamedirectory% so we can run the game with our launch options and change the process priority later on
call :1
call :2
call :3
REM go to the menu when first rnu check is done
goto :resolution_Selection

REM Check if the gameDirectory.txt is present,
REM If the file is not present prompt the user to enter the location at which the game executable is present
REM and save their input to gameDirectory.txt
:1
CLS
ECHO.
if defined gamelocation (
	ECHO Your current game location is: %gamelocation%
	ECHO.
)
if not exist "GameDirectory.txt" (
	ECHO Example: D:\Program Files\Genshin Impact\Genshin Impact Game
	ECHO.
	SET /p gamelocation="Enter the location where the game is installed: "
	) else (
		REM Import the location of the game's executable to a variable called gamelocation
		SET /p gamelocation=<"GameDirectory.txt"
)
exit /b
REM Check if the game's executable is present in %gamelocation%
:2
if not exist "%gamelocation%\GenshinImpact.exe" (
	ECHO.
	ECHO GenshinImpact.exe not found, please check the directory again.
	ECHO.
	REM Delete GameDirectory.txt if found as the directory saved in it doesn't contain the game's executable
	if exist "GameDirectory.txt" del /f /q "GameDirectory.txt"
	REM Prompt the user to enter the directory in which GenshinImpact.exe is located
	goto 1
)
exit /b
REM Save %gamelocation% to a text file called gameDirectory in the same folder as this script is ran from ("%cd%"")
:3
ECHO %gamelocation%>"GameDirectory.txt"
exit /b





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Confiration
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

:confirmation
CLS
REM Ask the user if they really want to run at (width: %screenWidth% - height: %screenHeight%)
ECHO Do you want to run the game in the following resolution:
ECHO.
ECHO.
ECHO Width: %screenWidth% - Height: %screenHeight%
ECHO.
ECHO.
SET /p i=Enter 1 to run the game at the above listed resolution, Enter 2 to go back to the resolution selection screen: 
if "%i%"=="1" (
	SET "i="
	goto DX11_Promt
) 
if "%i%"=="2" (
	SET "i="
	goto Resolution_Selection
) 
else (
	SET "i="
	goto Resolution_Selection
)





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Prompt Direct x 11
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM Launch the Game

:DX11_Promt
CLS
ECHO ==================================================
ECHO Do you want to fource directX 11
ECHO This is recommended for old hardwere
ECHO which may not support DirectX 12
ECHO And may improve perfermance
ECHO.
ECHO  Y: yes
ECHO  N: no
ECHO.
ECHO  0: go back to main menu
ECHO ==================================================
SET /p i=Input: 
if /i "%i%"=="y" (
	SET "i=" 
	SET "dx11=-force-d3d11"
	goto Check_ignPior
	)
if /i "%i%"=="n" (
	SET "i="
	SET "dx11="
	goto Check_ignPior
	)
	
if /i "%i%"=="0" ( 
	SET "i="
	SET "dx11=" 
	goto Resolution_Selection
	)
else (
	SET "i="
	set "dx11="
	goto DX11_Promt
)




REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Checck if ignor Piority is true
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM Launch the Game
:Check_ignPior
pause
if %ignorPiority% equ true (
	goto P

)
if if %ignorPiority% equ false (
	goto priority_Promt
)





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Prompt for Priortity Set
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:priority_Promt
ECHO ==================================================
ECHO Do you want to set the game to run at top priority?
ECHO.
ECHO  Y: yes
ECHO  N: no
ECHO.
ECHO.
ECHO ==================================================
SET /p i=Input: 
if /i "%i%"=="y" ( 
	set "i="
	goto Launch_Game
	
	)
if /i "%i%"=="n" ( 
	set "i="
	goto Launch_Game
	goto Nice_Message
	)
else (
	set "i="
	goto priority_Promt
)





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Set the priority
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:Set_Priority
rem Wait 30 seconds or until a user presses a key
TIMEOUT /t 30
REM Set the CPU priority to high
call "WMIC.exe" process where name="GenshinImpact.exe" CALL setpriority "128"
goto Nice_Message






REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Launch Genshi Impact
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM Launch the Game

:Launch_Game
rem CLS
rem Starting game with user define d configurations
echo Starting the game...

start "" "%gamelocation%"\GenshinImpact.exe -screen-width %screenWidth% -screen-height %screenHeight% %dx11%

pause





REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Leave a nice message
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:Nice_Message
CLS
REM Leave a nice message for the user
echo Ad astra abyssoque! traveler.
echo.
echo.
rem Wait for user input
pause
exit /b










































































REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM
REM Menus
REM
REM --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
REM Credit: https://github.com/shirooo39/Genshin-Impact-Set-Custom-Resolution

:Resolution_Selection
CLS
REM Ask the users at what resolution they want to play the game
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
ECHO  S. Set custom resolution
ECHO  U. Use presets
ECHO.
ECHO.
ECHO ==================================================
ECHO.
SET /p i=Input: 
if /i "%i%"=="S" ( 
	SET "i="
	goto Custom_Resolutions_Menu 
	)
if /i "%i%"=="U" ( 
	SET "i=" 
	goto Preset_Menu_Selections 
	)
else (
	set "i="
	goto Resolution_Selection
)



REM Custom Resolution Menu
:Custom_Resolutions_Menu
CLS
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
SET /p screenWidth=Set width : 
SET /p screenHeight= Set height: 
goto confirmation



REM Standard / Cinematic Selection
:Preset_Menu_Selections
CLS
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
ECHO  S: Standard Resolutions(16:9)
ECHO  C: Cinematic(21:9)
ECHO.
ECHO.
ECHO  0: to go back
ECHO ==================================================
ECHO.
SET /p i=Input: 
if /i "%i%"=="S" (
	SET "i="
	goto Standard_Resolution_Selection 
	)
if /i "%i%"=="C" (
	SET "i="
	goto Cinematic_Resolution_Selection
	)
if /i "%i%"=="0" (
	SET "i="
	goto Resolution_Selection
	)
else (
	set "i="
	goto Resolution_Selection
)



:Standard_Resolution_Selection
CLS
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
ECHO  S: Small
ECHO     [ 1366 x 768 ] - [ 800  x 600 ]
ECHO  B: Big
ECHO     [ 7680 x 4320 ] - [ 1600 x 900 ]
ECHO.
ECHO.
ECHO  0: go back
ECHO ==================================================
ECHO.
SET /p i=Input: 
if /i "%i%"=="S" (
	SET "i="
	goto Standard_small_Resolution_Selection
	)
if /i "%i%"=="B" (
	SET "i="
	goto Standard_BIG_Resolution_Selection
	)
if /i "%i%"=="0" (
	SET "i="
	goto Preset_Menu_Selections
	)
else (
	SET "i="
	goto Standard_Resolution_Selection
)



REM Standard_Small_Resolution_Selection
:Standard_Small_Resolution_Selection
CLS
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
ECHO   1. 1366 x 768 (16:9)     5. 900  x 600 (16:9)
ECHO   2. 1280 x 720 (16:9)     6. 854  x 480 (16:9)
ECHO   3. 1024 x 576 (16:9)     7. 800  x 600
ECHO   4. 960  x 540 (16:9)
ECHO.
ECHO.
ECHO   0. go back
ECHO ==================================================
ECHO.
SET /p i=Input: 
if "%i%"=="1" (
	SET "i="
	SET screenWidth=1366
	SET screenHeight=768
	goto confirmation
)
if "%i%"=="2" (
	SET "i="
	SET screenWidth=1280
	SET screenHeight=720
	goto confirmation
)
if "%i%"=="3" (
	SET "i="
	SET screenWidth=1024
	SET screenHeight=576
	goto confirmation
)
if "%i%"=="4" (
	SET "i="
	SET screenWidth=960
	SET screenHeight=540
	goto confirmation
)
if "%i%"=="5" (
	SET "i="
	SET screenWidth=900
	SET screenHeight=600
	goto confirmation
)
if "%i%"=="6" (
	SET "i="
	SET screenWidth=854
	SET screenHeight=480
	goto confirmation
)
if "%i%"=="7" (
	SET "i="
	SET screenWidth=800
	SET screenHeight=600
	goto confirmation
)
if "%i%"=="0" (
	set "i="
	goto Standard_Resolution_Selection
) else (
	SET "i="
	goto Standard_Small_Resolution_Selection
)



REM Standard_BIG_Resolution_Selection
:Standard_BIG_Resolution_Selection
CLS
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
ECHO   1. 7680 x 4320 (16:9) [Don't Ask, some ppl are rich]
ECHO   2. 5120 x 2880 (16:9)     5. 2560 x 1440 (16:9)
ECHO   3. 3840 x 2160 (16:9)     6. 1920 x 1080 (16:9)
ECHO   4. 3200 x 1080 (16:9)     7. 1600 x 900  (16:9)
ECHO.
ECHO.
ECHO   0. Back
ECHO ==================================================
ECHO.
SET /p i=Input: 
if "%i%"=="1" (
	SET "i="
	SET screenWidth=7680
	SET screenHeight=4320
	goto confirmation
)
if "%i%"=="2" (
	SET "i="
	SET screenWidth=5120
	SET screenHeight=2880
	goto confirmation
)
if "%i%"=="3" (
	SET "i="
	SET screenWidth=3840
	SET screenHeight=2160
	goto confirmation
)
if "%i%"=="4" (
	SET "i="
	SET screenWidth=3200
	SET screenHeight=1080
	goto confirmation
)
if "%i%"=="5" (
	SET "i="
	SET screenWidth=2560
	SET screenHeight=1440
	goto confirmation
)
if "%i%"=="6" (
	SET "i="
	SET screenWidth=1920
	SET screenHeight=1080
	goto confirmation
)
if "%i%"=="7" (
	SET "i="
	SET screenWidth=1600
	SET screenHeight=900
	goto confirmation
)
if "%i%"=="0" (
	set "i="
	goto Standard_Resolution_Selection
) else (
	SET "i="
	goto Standard_BIG_Resolution_Selection
)



REM Cinematic_Resolution_Selection
:Cinematic_Resolution_Selection
CLS
ECHO ==================================================
ECHO  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
ECHO ==================================================
ECHO.
ECHO  S: Small
ECHO     [ 1366 x 768 ] - [ 800  x 600 ]
ECHO  B: Big
ECHO     [ 7680 x 4320 ] - [ 1600 x 900 ]
ECHO.
ECHO.
ECHO  0: go back
ECHO ==================================================
ECHO.
SET /p i=Input: 
if /i "%i%"=="S" (
	SET "i="
	goto Standard_small_Resolution_Selection
	)
if /i "%i%"=="B" (
	SET "i="
	goto Standard_BIG_Resolution_Selection
	)
if /i "%i%"=="0" (
	SET "i="
	goto Preset_Menu_Selections
	)
else (
	SET "i="
	goto Preset_Menu_Selections
)