@if (@CodeSection == @Batch) @then

:: NSudoInstaller v3.1
:: Written by Th.Dub @ResonantStep - 2019
:: NSudo was created by Mouri Naruto https://github.com/MouriNaruto 
:: A big thank you to him.

@echo off
	set "NSudo_Files_Path=%~dp0\NSudoFolder\NSudo"
	set "NSudo_Additional_Files_Path=%~dp0\NSudoFolder\Additional_Files"
	%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>NUL 2>NUL || goto :NOADMIN

REM Path selection
	setlocal EnableDelayedExpansion
	echo Where do you want to install Nsudo?

REM Install browser
	for /f "delims=" %%a in ('CScript //nologo //E:JScript "%~F0" "Browse for location, or type the path where you want to install NSudo, then click OK."') do ( set "NSudoFolder=%%a")
	if "%NSudoFolder%" == "" ( cls & exit /b)
	echo NSudo will be installed in "%NSudoFolder%"
	<nul set /p dummyName=Press any key to proceed...
	pause >nul 2>&1

REM NSudo binaries installation
	robocopy "%NSudo_Files_Path%" "%NSudoFolder%" *.* /is /it /S >nul 2>&1
	echo Done.
	echo:

REM Customized Json 
	choice /C:YN /M "Do you want to install modified .json file?"
	if ERRORLEVEL 2 goto TILE
	robocopy "%NSudo_Additional_Files_Path%" "%NSudoFolder%" NSudo.json /is /it /S >nul 2>&1

REM Icons assets
:TILE
	choice /C:YN /M "Do you want to add Start Menu Tile/icon as well?"
	if ERRORLEVEL 2 goto STARTMENU
	robocopy "%NSudo_Additional_Files_Path%" "%NSudoFolder%" NSudo.visualelementsmanifest.xml *.png /is /it /S >nul 2>&1
REM Make "Images" folder and .xml hidden
	attrib +h "%NSudoFolder%\Images" >nul 2>&1
	attrib +h "%NSudoFolder%\NSudo.visualelementsmanifest.xml" >nul 2>&1

REM Create Start Menu shortcut
:STARTMENU
	choice /C:YN /M "Do you want to create Start Menu shortcut for NSudo.exe?"
	if ERRORLEVEL 2 goto CONTEXTMENU
	set "ShortcutScriptPath=%~dp0\Set_NSudo_Shortcut.ps1"
	set "start_menu_folder=%programdata%\Microsoft\Windows\Start Menu\Programs\System"
	if not exist "%start_menu_folder%" mkdir "%start_menu_folder%"
	Powershell -ExecutionPolicy Bypass -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%start_menu_folder%\Nsudo.lnk');$s.TargetPath='%NSudoFolder%\Nsudo.exe';$s.WorkingDirectory='%NSudoFolder%';$s.Description='Run programs as Trusted Installer';$s.Save()" >nul 2>&1
REM Make shortcut "run as administrator"
	set "ShortcutScriptPath=%~dp0\Set_NSudo_Shortcut.ps1"
	@echo $Destination = "%start_menu_folder%\NSudo.lnk" > "%ShortcutScriptPath%"
	@echo $bytes = [System.IO.File]::ReadAllBytes^($Destination^) >> "%ShortcutScriptPath%"
	@echo $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 ^(0x15^) bit 6 ^(0x20^) ON >> "%ShortcutScriptPath%"
	@echo [System.IO.File]::WriteAllBytes^($Destination, $bytes^) >> "%ShortcutScriptPath%"
	PowerShell -NoProfile -ExecutionPolicy Bypass -file "%ShortcutScriptPath%"
	del "%ShortcutScriptPath%" /f /s /q >NUL 2>&1
REM Refresh shortcut Icon
	Powershell -ExecutionPolicy Bypass -command "(ls "$env:programdata\Microsoft\Windows\Start Menu\Programs\System\Nsudo.lnk").lastwritetime = get-date" >nul 2>&1

:CONTEXTMENU
	echo:
REM Add NSudo to exefile shell
	<nul set /p dummyName=Setting Context Menu and CommandStore...
	reg add "HKCR\exefile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
	reg add "HKCR\exefile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
	reg add "HKCR\exefile\shell\NSudo" /v "Icon" /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\"" /f >nul 2>&1
	reg add "HKCR\exefile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
REM Add CommandStore entries
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System" /ve /t REG_SZ /d "Run As System" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:S -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges" /ve /t REG_SZ /d "Run As System (Enable All Privileges)" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:S -P:E -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller" /ve /t REG_SZ /d "Run As TrustedInstaller" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:T -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges" /ve /t REG_SZ /d "Run As TrustedInstaller (Enable All Privileges)" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges" /v "HasLUAShield" /t REG_SZ /d "" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:T -P:E -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >nul 2>&1
	echo Done.

REM Add Nsudo to environment variables path
	<nul set /p dummyName=Adding NSudo Install location to system environment variables path...
	for /f  "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "path" 2^>nul') do ( set "System_Env_Var_Path=%%b" )
REM Add path directly in case value is empty, to avoid problems with string replacements
	if "%System_Env_Var_Path%"=="" (
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "path" /t REG_EXPAND_SZ /d "%NSudoFolder%" /f >nul 2>&1
		goto :Install_Success
	)
REM Spaces and semicolons string replacement
	set "System_Env_Var_Path=%System_Env_Var_Path: =$%"
	set "System_Env_Var_Path=%System_Env_Var_Path:;= %"
	set "NSudoFolder=%NSudoFolder: =$%"
	setlocal EnableDelayedExpansion
	for %%a in (!System_Env_Var_Path!) do ( if "%%a"=="!NSudoFolder!" ( goto :Install_Success ))
REM Restore replaced spaces and semicolons
	set "System_Env_Var_Path=%System_Env_Var_Path: =;%"
	set "System_Env_Var_Path=%System_Env_Var_Path:$= %"
	set "NSudoFolder=%NSudoFolder:$= %"
REM Add semicolon before NSudo folder if path does not end with semicolon
	set "System_Env_Var_Path=%System_Env_Var_Path%;%NSudoFolder%;"
REM Replace semicolon duplicate if path ended with semicolon
	set "System_Env_Var_Path=%System_Env_Var_Path:;;=;%"
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "path" /t REG_EXPAND_SZ /d "%System_Env_Var_Path%" /f >nul 2>&1
	echo Done.

:Install_Success
	echo:
	<nul set /p dummyName=NSudo was successfully installed.
	TIMEOUT /T 5 /nobreak >nul 2>&1
	pause
	exit /b

:NOADMIN
	cls & echo You must have administrator rights to run this script.
	<nul set /p dummyName=Press any key to exit...
	pause >nul 2>&1
	cls & goto :eof

@end


var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, WScript.Arguments(0), 0x00000050,17);
WScript.Stdout.WriteLine(folder ? folder.self.path : "");