@echo off
rem Set the title of the command prompt
title GenshinImpact Resolution launcher script
rem Clear the screen of previous commands
cls

rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem
rem Permissions
rem
rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem Check if the script is being executed with admin priveleges (this is needed to change the process priority of the game later as its ran with admin priveleges as well)
rem If Permission Denai ask the user if they want limited performance
rem Credit: https://stackoverflow.com/questions/1894967/how-to-request-administrator-access-inside-a-batch-file

:: BatchGotAdmin
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
	echo !!!Permission Error!!!
	echo This scrpt needs administrative permission to set the task priority for genshinimpact.exe
	echo which for lower end hard where will give a performance boost, and pervent lagging.
	echo
	echo To ignor this error Input X (priority for genshinimpact.exe will not be set)
	echo To grent permission Input Y, but if denaied the script will exit
	set /p i=Input: 
	if /i "%i%"=="x" (
		set "i="
		set "ignorPiority=1"
		color 07
		goto info_NP
	)
	if /i "%i%"=="Y" (
		goto UACPrompt
	)

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"
    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
	goto info





rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem
rem Information
rem
rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

rem NO piroity Version
:info_NP
cls
echo Hello traveler!
echo.
echo The script will do the following things:
echo - Run the game at its lowest graphical preset
echo - Force DirectX11 to be used to render the game
echo.
echo.
echo. 
echo Credits:
echo  - u/loltheybannedshaman for his work on the reddit thread
echo  - Mathieu Squidward for his help with the issues i had
echo  - ElectroAegis for being an amazing tester
echo  - Rob van der Woude for his bat code checker
echo  - The people over at stackoverflow
echo  - shirooo39 over at GitHub for his work on the custom resolution part of this script
echo  - Little-Karl for the customization
echo.
echo.
echo.
rem Wait for user input
pause
cls
goto menu_process


rem Clear the screen and inform the users about what the script does
:info
cls
echo Hello traveler!
echo.
echo The script will do the following things:
echo - Run the game at its lowest graphical preset
echo - Force DirectX11 to be used to render the game
echo - Increase the process priority of the game after 30 seconds of launching the game 
echo - Little-Karl for the customization
echo.
echo. 
echo Credits:
echo  - u/loltheybannedshaman for his work on the reddit thread
echo  - Mathieu Squidward for his help with the issues i had
echo  - ElectroAegis for being an amazing tester
echo  - Rob van der Woude for his bat code checker
echo  - The people over at stackoverflow
echo  - shirooo39 over at GitHub for his work on the custom resolution part of this script
echo.
echo.
echo.
pause
cls
goto menu_process





rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem
rem First Run Check
rem
rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

:menu_process
@echo off
rem Setup the %gamedirectory% so we can run the game with our launch options and change the process priority later on
call :1
call :2
call :3

:resolution_Selection

rem Check if the gameDirectory.txt is present,
rem If the file is not present prompt the user to enter the location at which the game executable is present
rem and save their input to gameDirectory.txt
:1
cls
echo.
if defined gamelocation (
	echo Your current game location is: %gamelocation%
	echo.
)
if not exist "GameDirectory.txt" (
	echo Example: D:\Program Files\Genshin Impact\Genshin Impact Game
	echo.
	set /p gamelocation="Enter the location where the game is installed: "
	) else (
		rem Import the location of the game's executable to a variable called gamelocation
		set /p gamelocation=<"GameDirectory.txt"
)
exit /b
rem Check if the game's executable is present in %gamelocation%
:2
if not exist "%gamelocation%\GenshinImpact.exe" (
	echo.
	echo GenshinImpact.exe not found, please check the directory again.
	echo.
	rem Delete GameDirectory.txt if found as the directory saved in it doesn't contain the game's executable
	if exist "GameDirectory.txt" del /f /q "GameDirectory.txt"
	rem Prompt the user to enter the directory in which GenshinImpact.exe is located
	goto 1
)
exit /b
rem Save %gamelocation% to a text file called gameDirectory in the same folder as this script is ran from ("%cd%"")
:3
echo %gamelocation%>"GameDirectory.txt"
exit /b





rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem
rem Conferation
rem
rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------

:confirmation
rem Clear the screen of previous commands
cls

rem Ask the user if they really want to run at (width: %screenWidth% - height: %screenHeight%)
echo Do you want to run the game in the following resolution:
echo.
echo.
echo Width: %screenWidth% - Height: %screenHeight%
echo.
echo.
set /p i=Enter 1 to run the game at the above listed resolution, Enter 2 to go back to the resolution selection screen: 
if "%i%"=="1" (
	set "i="
	goto run_Genshin
) else (
	set "i="
	goto resolution_Selection
)





rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem
rem Menus
rem
rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
rem Credit: https://github.com/shirooo39/Genshin-Impact-Set-Custom-Resolution

:resolution_Selection
cls
rem Ask the users at what resolution they want to play the game
echo ==================================================
echo  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
echo ==================================================
echo.
echo  S. Set custom resolution
echo  U. Use presets
echo.
echo.
echo ==================================================
echo.
set /p i=Input: 
if /i "%i%"=="S" ( goto Custom_Resolutions_Menu )
if /i "%i%"=="U" ( goto Preset_Menu_Selections )

rem Custom Resolution Menu
:Custom_Resolutions_Menu
cls
echo ==================================================
echo  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
echo ==================================================
echo.
set /p screenWidth=Set width : 
set /p screenHeight= Set height: 
goto confirmation

rem Standard / Cinematic Selection
:Preset_Menu_Selections
cls
echo ==================================================
echo  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
echo ==================================================
echo.
echo  S: Standard Resolutions(16:9)
echo  C: Cinematic(21:9)
echo.
echo.
echo ==================================================
echo.
set /p i=Input: 
if /i "%i%"=="S" ( goto Standard_Resolution_Selection )
if /i "%i%"=="U" ( goto Cinematic_Resolution_Selection )




:Standard_Resolution_Selection
rem Preset BIG/Small Selection
:Preset_Menu_Selections
cls
echo ==================================================
echo  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
echo ==================================================
echo.
echo  S: Standard Resolutions(16:9)
echo  C: Cinematic(21:9)
echo.
echo.
echo ==================================================
echo.
set /p i=Input: 
if /i "%i%"=="S" ( goto Standard_Resolution_Selection )
if /i "%i%"=="U" ( goto Cinematic_Resolution_Selection )











:Cinematic_Resolution_Selection
































































:M-Res-P
cls
rem Ask the users at what resolution they want to play the game
echo ==================================================
echo  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
echo ==================================================
echo.
echo  S: Small Resolutions
echo  B: Big Resolutions
echo.
echo.
echo ==================================================
echo.
set /p i=Input: 
if /i "%i%"=="S" (
	set "i="
	goto 
)
if /i "%i%"=="U" (
	set "i="
	goto 
)











rem Small Resolutions
rem --------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:small_res
cls
echo ==================================================
echo  Genshin Impact    (width: %screenWidth% - height: %screenHeight%)
echo ==================================================
echo.
echo   1. 1366 x 768 (16:9)     5. 900  x 600 (16:9)
echo   2. 1280 x 720 (16:9)     6. 854  x 480 (16:9)
echo   3. 1024 x 576 (16:9)     7. 800  x 600
echo   4. 960  x 540 (16:9)
echo.
echo   0. Back
echo.
echo ==================================================
echo.
set /p i=Input: 
if "%i%"=="1" (
	set "i="
	set screenWidth=1366
	set screenHeight=768
	goto confirmation
)
if "%i%"=="2" (
	set "i="
	set screenWidth=1280
	set screenHeight=720
	goto confirmation
)
if "%i%"=="3" (
	set "i="
	set screenWidth=1024
	set screenHeight=576
	goto confirmation
)
if "%i%"=="4" (
	set "i="
	set screenWidth=960
	set screenHeight=540
	goto confirmation
)
if "%i%"=="5" (
	set "i="
	set screenWidth=900
	set screenHeight=600
	goto confirmation
)
if "%i%"=="6" (
	set "i="
	set screenWidth=854
	set screenHeight=480
	goto confirmation
)
if "%i%"=="7" (
	set "i="
	set screenWidth=800
	set screenHeight=600
	goto confirmation
)
if "%i%"=="0" (
	set "i="
	goto M-Res_Sel
) else (
	set "i="
	goto M-Res_Sel
)























