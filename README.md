# NSudo Installer
Batch script installer for NSudo, with additional options.

-Install NSudo binaries and .json file in custom location through a browser: You can either enter installation path manually, or browse to desired location.

-Add NSudo installation path to system environment variables paths: This way you can juste write "NSudo", instead of writing whole "NSudo installation path" in your batch files using NSudo. 

Pure batch script: No external binaries are required.

# NSudo Installer Options
Installer options, asks for user choice.

- Add modified .json file for Nsudo.exe "Open" descending menu, with:
"Task Scheduler", "Registry Editor", "PowerShell", "hosts file", "Component Services" and "Command prompt"
and in Latin characters

- Add custom Tiles: Bigger and transparent icons for Start Menu pinning

- Create Start Menu shortcut to NSudo.exe

- Add NSudo Context Menu and choose display options between
all files: HKEY_CLASSES_ROOT\*\shell 
or
exe files and batch scripts only: .exe .bat .cmd .inf .ps1 .py .reg .vbs

- Add uninstall support: Uninstall NSudo through Windows "Programs and Features"
No files are created during installation, uninstallation is done with pure batch script commands from registry

Download NSudo installer : https://github.com/Thdub/NSudo_Installer/releases
Download NSudo : https://github.com/M2Team/NSudo/releases
