$date = Get-date -Format yyyyMMddss
Start-Transcript -Append C:\Temp\PSScriptLog$date.txt

#Load the hive
reg load HKLM\SICustom "C:\Users\Default\NTUSER.DAT"

#reg query
reg Query "HKEY_LOCAL_MACHINE\SICustom\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\Temp\RegQueryBefore.txt
#eg Query "HKEY_LOCAL_MACHINE\SICustom\Software\Microsoft\Windows\CurrentVersion\Themes" /s
    
# Set variables to indicate value and key to set
#$RegistryPath = 'HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -Value "C:\Windows\Resources\Themes\themeB.theme" -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "WallpaperSetFromTheme" -Value "1" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "ColorSetFromTheme" -Value "1" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLighTheme" -Value "0" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUsesLightTheme" -Value "0" -PropertyType DWORD -Force

#close registry because I have access denied to unload the hive.
taskkill /f /im regedit.exe

#Unload the hive saving the changes
reg unload HKLM\SICustom

#need to create output
Stop-Transcript
