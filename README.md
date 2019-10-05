# NSudo Installer
Batch script installer for NSudo, with additional options.
- Install NSudo binaries and .json file in custom location, with a convenient browser: 
  - "Enter installation path manually in text box, or browse to desired location.
- Add NSudo installation path to system environment variables paths:
  - This way you can juste write "NSudo", instead of writing whole "NSudo path" in your batch scripts using NSudo. 

Pure batch script: No external binaries are required.

# NSudo Installer Options
Installer options, to the user choice.
- Add modified .json file for Nsudo.exe "Open" descending menu, with:
  - Task Scheduler, Registry Editor, PowerShell, hosts file, Component Services, Command prompt
  - And in Latin characters.
- Add custom Tiles: Bigger and transparent icons for Start Menu pinning.
- Create Start Menu shortcut to NSudo.exe.
- Choose NSudo Context Menu display options between:
  - All files: HKEY_CLASSES_ROOT\*\shell
  - exe files and batch scripts only: .exe  .bat  .cmd  .inf  .ps1  .py  .reg  .vbs
- Add uninstall support: Uninstall NSudo through Windows "Programs and Features".
  - No files are created during installation, uninstallation is done with batch script commands in registry.

# Downloads
- Download NSudo installer batch script : https://github.com/Thdub/NSudo_Installer/releases
- Download NSudo installer executable : https://github.com/Thdub/NSudo_Installer/releases
- Download NSudo : https://github.com/M2Team/NSudo/releases
