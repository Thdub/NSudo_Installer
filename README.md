# NSudo Launcher Installer  
Batch script AIO installer for NSudo Launcher (x64, x86, ARM64, ARM) with additional options.  
Extracts and Installs NSudo binaries and .json file in custom location, with a convenient browser.  
Pure batch script : No external binaries are required.  

# Install  
1. Launch .bat as administrator.  
2. Browse to desired location, or paste an existing path - either in address bar or message box - then click "Select Folder" button.  
Note: You can edit "root_perm" value at top of script.  
- Set value to 1. Allow root installation (like "C:\")  
- Set value to 0. Prohibit root installation. (default value)   
3. Select Options  

# NSudo Launcher Installer Options  
Installer options, at the user choice.  

- Add modified .json file for Nsudo.exe "Open" descending menu, with :  
  - Task Scheduler, Registry Editor, PowerShell, hosts file, Component Services, Command prompt.  
  - In Latin characters (original .json contains Chinese characters).  
- Create Start Menu shortcut to NSudoLG.exe in "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\".  
  - Set option to 1 to create shortcut anywhere you like.  
  - Set option to 0 (default) to restrict shortcut creation to Start Menu(s) and Start Menu(s) subfolders. 
- Add Start Menu tranparent tiles : Bigger and transparent icons for Start Menu pinning.  
- Choose NSudo Context Menu display options between :  
  - All files: HKEY_CLASSES_ROOT\*\shell\NSudo  
  - exe files and batch scripts: .exe  .bat  .cmd  .inf  .ps1  .py  .reg  .vbs  
  - exe files only  
- Add NSudo installation path to system environment variables paths :  
  - This way you can juste write "NSudo" instead of "whole NSudo path" in your batch scripts using NSudo. 
- Add Uninstall Support: Uninstall NSudo through Windows "Programs and Features".  
  - NO FILES are created during installation, uninstallation is done 100% with script commands from registry.  

# Downloads  
Download NSudo Installer : https://github.com/Thdub/NSudo_Installer/releases  
Download NSudo : https://github.com/M2Team/NSudo/releases  

# Screenshots:
Installer :  
![Process](http://u.cubeupload.com/qrP722m4/45kw47.png)  

"Vista Style" Folder Picker :  
![Browser](http://u.cubeupload.com/qrP722m4/eL3rPi.png)

Uninstall :  
![Uninstall](http://u.cubeupload.com/qrP722m4/kHc5w6.png)
