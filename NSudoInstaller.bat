@if (@CodeSection == @Batch) @then

:: NSudoInstaller v3.0
:: Written by Th.Dub @ResonantStep - 2019
:: NSudo was created by Mouri Naruto https://github.com/MouriNaruto 
:: A big thank you to him.

@echo off
	set "Tmp_Path=%~dp0\NSudoFolder"
	%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>NUL 2>NUL || goto :NOADMIN

:PathSelection
	setlocal EnableDelayedExpansion
	echo Where do you want to install Nsudo?
:: Hybrid browser
	for /f "delims=" %%a in ('CScript //nologo //E:JScript "%~F0" "Browse for location, or type the path where you want to install NSudo, then click OK."') do ( set "NSudoFolder=%%a")
	if "%NSudoFolder%" == "" ( cls & exit /b)
	echo NSudo will be installed in %NSudoFolder% 
	echo:
	mkdir "%Tmp_Path%" >NUL 2>&1

:: Installation
	robocopy "%Tmp_Path%" "%NSudoFolder%" *.exe >NUL 2>&1
	choice /C:YN /M "Do you want to install modified .json file?"
	if ERRORLEVEL 2 goto TILE
	robocopy "%Tmp_Path%" "%NSudoFolder%" NSudo.json >NUL 2>&1

:TILE
	choice /C:YN /M "Do you want to add Start Menu Tile/icon as well?"
	if ERRORLEVEL 2 goto STARTMENU
	robocopy "%Tmp_Path%" "%NSudoFolder%" NSudo.visualelementsmanifest.xml >NUL 2>&1
	xcopy "%TEMP%\NSudoInstall\Images" "%NSudoFolder%\Images" /e /h /k /i /y >NUL 2>&1
	attrib +h "%NSudoFolder%\Images" >NUL 2>&1
	attrib +h "%NSudoFolder%\NSudo.visualelementsmanifest.xml" >NUL 2>&1

:STARTMENU
	choice /C:YN /M "Do you want to add Start Menu shortcut for NSudo.exe?"
	if ERRORLEVEL 2 goto CONTEXTMENU
:: Create shortcut
	set "ShortcutScriptPath=%~dp0\Set_NSudo_Shortcut.ps1"
	set "start_menu_folder=%programdata%\Microsoft\Windows\Start Menu\Programs\System"
	if not exist "%start_menu_folder%" mkdir "%start_menu_folder%"
	Powershell -ExecutionPolicy Bypass -command "$s=(New-Object -COM WScript.Shell).CreateShortcut('%start_menu_folder%\Nsudo.lnk');$s.TargetPath='%NSudoFolder%\Nsudo.exe';$s.WorkingDirectory='%NSudoFolder%';$s.Description='Run programs as Trusted Installer';$s.Save()" >NUL 2>&1
:: Run as admin shortcut
	set "ShortcutScriptPath=%~dp0\Set_NSudo_Shortcut.ps1"
	@echo $Destination = "%start_menu_folder%\NSudo.lnk" > "%ShortcutScriptPath%"
	@echo $bytes = [System.IO.File]::ReadAllBytes^($Destination^) >> "%ShortcutScriptPath%"
	@echo $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 ^(0x15^) bit 6 ^(0x20^) ON >> "%ShortcutScriptPath%"
	@echo [System.IO.File]::WriteAllBytes^($Destination, $bytes^) >> "%ShortcutScriptPath%"
	PowerShell -NoProfile -ExecutionPolicy Bypass -file "%ShortcutScriptPath%"
	del "%ShortcutScriptPath%" /f /s /q >NUL 2>&1
:: Update icon display
	Powershell -ExecutionPolicy Bypass -command "(ls "$env:programdata\Microsoft\Windows\Start Menu\Programs\Systemtest\Nsudo.lnk").lastwritetime = get-date" >NUL 2>&1

:CONTEXTMENU
	echo:
:: Add NSudo to exefile shell
	<nul set /p dummyName=Setting Context Menu and CommandStore...
	reg add "HKCR\exefile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >NUL 2>&1
	reg add "HKCR\exefile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >NUL 2>&1
	reg add "HKCR\exefile\shell\NSudo" /v "Icon" /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\"" /f >NUL 2>&1
	reg add "HKCR\exefile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >NUL 2>&1

:: Create CommandStore
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System" /ve /t REG_SZ /d "Run As System" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System" /v "HasLUAShield" /t REG_SZ /d "" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:S -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges" /ve /t REG_SZ /d "Run As System (Enable All Privileges)" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges" /v "HasLUAShield" /t REG_SZ /d "" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:S -P:E -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller" /ve /t REG_SZ /d "Run As TrustedInstaller" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller" /v "HasLUAShield" /t REG_SZ /d "" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:T -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges" /ve /t REG_SZ /d "Run As TrustedInstaller (Enable All Privileges)" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges" /v "HasLUAShield" /t REG_SZ /d "" /f >NUL 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges\command" /ve /t REG_SZ /d "\"%NSudoFolder%\NSudo.exe\" -U:T -P:E -ShowWindowMode=Hide cmd /c start \"NSudo.ContextMenu.Launcher\" \"%%1\"" /f >NUL 2>&1
	echo Done.
:: Add Nsudo to Environment Variables Path
	<nul set /p dummyName=Setting Nsudo Environment Variable Path...
	"%~dp0pathman" /as "%NSudoFolder%"
	echo Done.
	
:: Echo success
	echo:
	<nul set /p dummyName=NSudo was successfully installed.
	TIMEOUT /T 3 /nobreak >NUL 2>&1
	exit /b

:NOADMIN
	cls & echo You must have administrator rights to run this script.
	<nul set /p dummyName=Press any key to exit...
	pause >NUL 2>&1
	cls & goto :eof

@end


var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0, WScript.Arguments(0), 0x00000050,17);
WScript.Stdout.WriteLine(folder ? folder.self.path : "");