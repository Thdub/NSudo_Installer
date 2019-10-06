# NSudo Installer
Batch script installer for NSudo, with additional options.
- Install NSudo binaries and .json file in custom location, with a convenient browser :
  - Enter installation path in Text Box or browse to desired location.
  - Choose an existing folder or create a new folder.

Pure batch script: No external binaries are required.

# NSudo Installer Options
Installer options, to the user choice.
- Add modified .json file for Nsudo.exe "Open" descending menu, with :
  - Task Scheduler, Registry Editor, PowerShell, hosts file, Component Services, Command prompt
  - In Latin characters (original .json contains Chinese characters)
- Create Start Menu shortcut to NSudo.exe in "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\"
- Add Start Menu tranparent tiles : Bigger and transparent icons for Start Menu pinning.
- Choose NSudo Context Menu display options between :
  - All files : HKEY_CLASSES_ROOT\*\shell\NSudo
  - exe files and batch scripts : .exe  .bat  .cmd  .inf  .ps1  .py  .reg  .vbs
  - exe files only
- Add NSudo installation path to system environment variables paths :
  - This way you can juste write "NSudo" instead of "whole NSudo path" in your batch scripts using NSudo. 
- Add uninstall support : Uninstall NSudo through Windows "Programs and Features".
  - No files are created during installation, uninstallation is done with script commands from registry.

# Downloads
- Download NSudo Installer : https://github.com/Thdub/NSudo_Installer/releases
- Download NSudo : https://github.com/M2Team/NSudo/releases
