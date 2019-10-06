@if (@CodeSection == @Batch) @then
@echo off

:: NSudo Installer v3.2
:: Written by Thomas Dubreuil @ResonantStep - 2019 | https://github.com/Thdub
:: NSudo was created by Mouri Naruto | https://github.com/MouriNaruto

REM Files variables
	set "NSudo_Files_Path=%~dp0\Install_Files\NSudo"
	set "NSudo_Additional_Files_Path=%~dp0\Install_Files\Additional_Files"
	set "Start_Menu_Folder=C:\ProgramData\Microsoft\Windows\Start Menu\Programs"

REM Script variables
	set "windir=C:\Windows"
	set "PScommand=%windir%\System32\WindowsPowerShell\v1.0\powershell.exe -NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass"
	set "colors=blue=[94m,green=[92m,red=[31m,yellow=[93m,white=[97m
	set "%colors:,=" & set "%"
	set "Yes=%green%Yes%white%"
	set "No=%red%No%white%"
	set "hide_cursor=[?25l"
	set "show_cursor=[?25h"

REM Title bar
	echo %white%]0;NSudo Installer%hide_cursor%
	cls

REM Check administrator rights
	%windir%\system32\reg.exe query "HKU\S-1-5-19" 1>NUL 2>NUL || goto :NOADMIN

REM Path selection
:Installation_Browser
	echo Where do you want to install NSudo?
	for /f "delims=" %%a in ('CScript //nologo //E:JScript "%~F0" "Browse for location, or type the path where you want to install NSudo, then click OK."') do ( set "NSudoFolder=%%a" )
	if "%NSudoFolder%"=="" ( cls & exit /b )
	if "%NsudoFolder%"=="::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" (
		cls
		echo The path does not exist.
		echo Choose an existing folder, or use the "Make New Folder" button to create one.
		set "NSudoFolder="
		echo:
		goto :Installation_Browser
	)
	cls
	echo NSudo will be installed in "%NSudoFolder%"%show_cursor%
	<nul set /p dummyName=Press any key to proceed...
	pause >nul 2>&1

REM NSudo binaries installation
	robocopy "%NSudo_Files_Path%" "%NSudoFolder%" *.* /is /it /S >nul 2>&1
	echo %yellow%Done.%white%
	echo:

REM Customized .json choice
	<nul set /p DummyName=Do you want to install modified .json file? [Y/N]
	choice /C:YN >nul 2>&1
	if errorlevel 2 ( echo %No%& goto :Start_Menu )
	if errorlevel 1 echo %Yes%
	robocopy "%NSudo_Additional_Files_Path%" "%NSudoFolder%" NSudo.json /is /it /S >nul 2>&1

:Start_Menu
REM Create Start Menu shortcut choice
	<nul set /p DummyName=Do you want create Start Menu shortcut for NSudo.exe? [Y/N]
	choice /C:YN >nul 2>&1
	if errorlevel 2 ( echo %No%& goto :Context_Menu )
	if errorlevel 1 echo %Yes%
	set "Tmp_Shortcut_Script_Path=%~dp0\Set_NSudo_Shortcut.ps1"
	if not exist "%Start_Menu_Folder%" mkdir "%Start_Menu_Folder%"
	%PScommand% "$s=(New-Object -COM WScript.Shell).CreateShortcut('%Start_Menu_Folder%\NSudo.lnk');$s.TargetPath='%NSudoFolder%\NSudo.exe';$s.WorkingDirectory='%NSudoFolder%';$s.Description='Run programs as Trusted Installer';$s.Save()" >nul 2>&1
REM Make shortcut "run as administrator"
	@echo $Destination = "%Start_Menu_Folder%\NSudo.lnk" > "%Tmp_Shortcut_Script_Path%"
	@echo $bytes = [System.IO.File]::ReadAllBytes^($Destination^) >> "%Tmp_Shortcut_Script_Path%"
	@echo $bytes[0x15] = $bytes[0x15] -bor 0x20 #set byte 21 ^(0x15^) bit 6 ^(0x20^) ON >> "%Tmp_Shortcut_Script_Path%"
	@echo [System.IO.File]::WriteAllBytes^($Destination, $bytes^) >> "%Tmp_Shortcut_Script_Path%"
	%PScommand% -file "%Tmp_Shortcut_Script_Path%" >nul 2>&1
	del /F /Q /S "%Tmp_Shortcut_Script_Path%" >nul 2>&1

REM Title bar
	<nul set /p DummyName=]0;NSudo Installer

REM Start_Menu_Tiles choice
	<nul set /p DummyName=Do you want to add transparent Start Menu tiles? [Y/N]
	choice /C:YN >nul 2>&1
	if errorlevel 2 ( echo %No%& goto :Context_Menu )
	if errorlevel 1 echo %Yes%
	robocopy "%NSudo_Additional_Files_Path%" "%NSudoFolder%" NSudo.visualelementsmanifest.xml *.png /is /it /S >nul 2>&1
REM Make "Images" folder and .xml hidden
	attrib +h "%NSudoFolder%\Images" >nul 2>&1
	attrib +h "%NSudoFolder%\NSudo.visualelementsmanifest.xml" >nul 2>&1
REM Refresh shortcut Icon
	%PScommand% -c "(ls '%Start_Menu_Folder%\Nsudo.lnk').lastwritetime = get-date" >nul 2>&1

REM Title bar
	<nul set /p DummyName=]0;NSudo Installer

:Context_Menu
REM Context Menu choice
	echo Do you want to add NSudo Context Menu entries:
	<nul set /p DummyName=For all files ^(1^) for .exe and scripts files ^(2^) for .exe only ^(3^)? [1/2/3]
	choice /C:123 >nul 2>&1
	if errorlevel 3 ( echo %yellow%3%white%& set "Shell_Installation=Minimal" & goto :Context_Menu_Task )
	if errorlevel 2 ( echo %yellow%2%white%& set "Shell_Installation=Clean" & goto :Context_Menu_Task )
	if errorlevel 1 ( echo %yellow%1%white%& set "Shell_Installation=All" & goto :Context_Menu_Task )

:Context_Menu_Task
REM Add NSudo to * shell
	if "%Shell_Installation%"=="All" (
		reg add "HKCR\*\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\*\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\*\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\*\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
	)
REM Add NSudo to custom classes
	if "%Shell_Installation%"=="Clean" (
		reg add "HKCR\exefile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\exefile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\exefile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\exefile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\batfile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\batfile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\batfile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\batfile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\cmdfile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\cmdfile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\cmdfile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\cmdfile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\Microsoft.PowerShellScript.1\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\Microsoft.PowerShellScript.1\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\Microsoft.PowerShellScript.1\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\Microsoft.PowerShellScript.1\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\inffile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\inffile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\inffile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\inffile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\Python\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\Python\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\Python\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\Python\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\regfile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\regfile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\regfile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\regfile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
		reg add "HKCR\VBSFile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\VBSFile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\VBSFile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\VBSFile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
	)
REM Add NSudo to exefile class only
	if "%Shell_Installation%"=="Minimal" (
		reg add "HKCR\exefile\shell\NSudo" /v "SubCommands" /t REG_SZ /d "NSudo.RunAs.TrustedInstaller;NSudo.RunAs.TrustedInstaller.EnableAllPrivileges;NSudo.RunAs.System;NSudo.RunAs.System.EnableAllPrivileges;" /f >nul 2>&1
		reg add "HKCR\exefile\shell\NSudo" /v "MUIVerb" /t REG_SZ /d "NSudo" /f >nul 2>&1
		reg add "HKCR\exefile\shell\NSudo" /v "Icon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
		reg add "HKCR\exefile\shell\NSudo" /v "Position" /t REG_SZ /d "1" /f >nul 2>&1
	)
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

:Environment_Variables_Task
REM Add NSudo to environment variables path choice
	<nul set /p DummyName=Do you want to add NSudo location to environment variables path? [Y/N]
	choice /C:YN >nul 2>&1
	if errorlevel 2 ( echo %No%& goto :Uninstall_Support )
	if errorlevel 1 echo %Yes%
REM Reg query
	for /f  "tokens=2*" %%a in ('reg query "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "path" 2^>nul') do ( set "System_Env_Var_Path=%%b" )
REM Add path directly in case value is empty, to avoid problems with string replacements
	if "%System_Env_Var_Path%"=="" (
		reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "path" /t REG_EXPAND_SZ /d "%NSudoFolder%" /f >nul 2>&1
		goto :Uninstall_Support
	)
REM Spaces and semicolons string replacement
	setlocal EnableDelayedExpansion
	set "System_Env_Var_Path=%System_Env_Var_Path: =$%"
	set "System_Env_Var_Path=%System_Env_Var_Path:;= %"
	set "NSudoFolder=%NSudoFolder: =$%"
REM Bypass task if NSudo folder path exist
	for %%a in (!System_Env_Var_Path!) do ( if "%%a"=="!NSudoFolder!" (
		set "System_Env_Var_Path=%System_Env_Var_Path: =;%"
		set "System_Env_Var_Path=%System_Env_Var_Path:$= %"
		set "NSudoFolder=%NSudoFolder:$= %"
		setlocal DisableDelayedExpansion
		goto :Uninstall_Support
	))
REM Restore replaced spaces and semicolons
	set "System_Env_Var_Path=%System_Env_Var_Path: =;%"
	set "System_Env_Var_Path=%System_Env_Var_Path:$= %"
	set "NSudoFolder=%NSudoFolder:$= %"
REM Add semicolon before NSudo folder if path does not end with semicolon
	set "System_Env_Var_Path=%System_Env_Var_Path%;%NSudoFolder%;"
REM Replace semicolon duplicate if path ended with semicolon
	set "System_Env_Var_Path=%System_Env_Var_Path:;;=;%"
	reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /v "path" /t REG_EXPAND_SZ /d "%System_Env_Var_Path%" /f >nul 2>&1
	setlocal DisableDelayedExpansion

:Uninstall_Support
REM Uninstall Support choice
	<nul set /p DummyName=Do you want to add Uninstall Support? [Y/N]
	choice /C:YN >nul 2>&1
	if errorlevel 2 ( echo %No%& goto :Install_Success )
	if errorlevel 1 echo %Yes%
	for /f "tokens=1, 2, 3, 4 delims=-/. " %%a in ("%DATE%") do set "NSudo_Install_Date=%%c%%b%%a"
	set "UserName=%username%"
	set "TEMP=%systemdrive%\Users\%UserName%\AppData\Local\Temp"
REM Split Uninstall command
	set "Un_Script=cmd /q /c echo Windows Registry Editor Version 5.00>\"%TEMP%\Un_NSudo.reg\"& echo.>>\"%TEMP%\Un_NSudo.reg\""
	set "Un_Script_1=echo [-HKEY_CLASSES_ROOT\*\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\batfile\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\cmdfile\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\exefile\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\inffile\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\Microsoft.PowerShellScript.1\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\Python\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\regfile\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_CLASSES_ROOT\VBSFile\shell\NSudo]>>\"%TEMP%\Un_NSudo.reg\""
	set "Un_Script_2=echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.System.EnableAllPrivileges]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller]>>\"%TEMP%\Un_NSudo.reg\"& echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\CommandStore\shell\NSudo.RunAs.TrustedInstaller.EnableAllPrivileges]>>\"%TEMP%\Un_NSudo.reg\""
	set "Un_Script_3=echo [-HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo]>>\"%TEMP%\Un_NSudo.reg\"& regedit /s \"%TEMP%\Un_NSudo.reg\" >nul 2>&1"
	set "Un_Script_4=attrib -h \"%NSudoFolder%\NSudo.visualelementsmanifest.xml\" & del /F /Q /S \"%TEMP%\Un_NSudo.reg\" \"%NSudoFolder%\NSudo.exe\" \"%NSudoFolder%\NSudoC.exe\" \"%NSudoFolder%\NSudoG.exe\" \"%NSudoFolder%\NSudo.json\" \"%NSudoFolder%\NSudo.exe\" \"%NSudoFolder%\NSudo.visualelementsmanifest.xml\" \"%Start_Menu_Folder%\NSudo.lnk\" >nul 2>&1 & rmdir \"%NSudoFolder%\Images\" /s /q & rmdir \"%NSudoFolder%\" >nul 2>&1"
	set "Uninstall_Command=%Un_Script%& %Un_Script_1%& %Un_Script_2%& %Un_Script_3%& %Un_Script_4%"
REM Uninstaller keys
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "DisplayName" /t REG_SZ /d "NSudo" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "DisplayIcon" /t REG_SZ /d "%NSudoFolder%\NSudo.exe" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "DisplayVersion" /t REG_SZ /d "6.2.1812.31" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "InstallLocation" /t REG_SZ /d "%NSudoFolder%\\" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "InstallDate" /t REG_SZ /d "%NSudo_Install_Date%" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "NoModify" /t REG_DWORD /d "1" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "NoRepair" /t REG_DWORD /d "1" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "Publisher" /t REG_SZ /d "M2-Team" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "UninstallString" /t REG_SZ /d "%Uninstall_Command%" /f >nul 2>&1
	reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\NSudo" /v "URLInfoAbout" /t REG_SZ /d "https://github.com/M2Team/NSudo" /f >nul 2>&1

:Install_Success
	echo:
	echo %yellow%NSudo was successfully installed.%white%
	<nul set /p dummyName=Press any key to exit...
	pause >nul 2>&1
	exit /b

:NOADMIN
	cls & echo You must have administrator rights to run this script.
	<nul set /p dummyName=Press any key to exit...
	pause >nul 2>&1
	cls & goto :eof

@end


var shl = new ActiveXObject("Shell.Application");
var folder = shl.BrowseForFolder(0,WScript.Arguments(0),0x50,17);
WScript.Stdout.WriteLine(folder ? folder.self.path : "");
