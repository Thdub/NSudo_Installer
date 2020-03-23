# NSudo Launcher Installer  
Batch script AIO installer for NSudo Launcher (x64, x86, ARM64, ARM) with additional options.  
Extracts and Installs NSudo binaries and .json file in custom location, with a convenient browser.  
Pure batch script : No external binaries are required.  

# Install  
1. Launch .bat as administrator.  
2. Browse to desired location, or paste an existing path - either in address bar or message box - then click "Select Folder" button.  
3. Select Options  

Pre-install notes : You can edit the following values at the beginning of the script  
```
Root_Perm
- Set value to 1 : Allow root installation (like "C:\")  
- Set value to 0 : Do not allow installing NSudo Launcher at root of a drive (default value)  
```
```
Shortcut_Path
- Set value to 1 : Create shortcut anywhere you like  
- Set value to 0 : Shortcut creation is restricted to Start Menu(s) and Start Menu(s) subfolders (default value)  
```
```
Debug
- Set value to 1 : Install .pdb debug files 
- Set value to 0 : Do not install .pdb debug files (default value)  
```
# NSudo Launcher Installer Options  
Installer options, at the user choice.  

- Add modified NSudo.json file, for NsudoLG "Open" descending menu, with :  
  - Task Scheduler, Registry Editor, PowerShell, hosts file, Component Services, Command prompt.  
  - In Latin characters (original .json contains Chinese characters).  
- Create Start Menu shortcut to NSudoLG.exe
  - "Select Folder" dialog default browsing location is set to "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\".
  - Default shorcut location is restricted to Start Menus - "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\" or "C:\Users\%username%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs" - folders and subfolders.
  - Set option to 1 to create a shortcut anywhere you like. This also changes "Select Folder" dialog default browsing location to "This PC".
  - Set option to 0 (default) to restrict shortcut creation to Start Menu(s) and Start Menu(s) subfolders. 
- Add Start Menu tranparent tiles : Bigger and transparent icons for Start Menu pinning.  
- Choose NSudo Context Menu display options between :  
  - All files: HKEY_CLASSES_ROOT\*\shell\NSudo  
  - exe files and batch scripts: .exe  .bat  .cmd  .inf  .ps1  .py  .reg  .vbs  
  - exe files only  
- Add NSudo installation path to system environment variables paths :  
  - This way you can juste write "NSudoLC" or "NSudoLG" in your batch scripts or commands instead of whole path.   
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
