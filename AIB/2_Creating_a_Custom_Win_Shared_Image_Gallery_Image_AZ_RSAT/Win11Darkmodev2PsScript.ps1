$date = Get-date -Format yyyyMMddss
Start-Transcript -Append C:\Temp\PSScriptLog$date.txt

#Load the hive
reg load HKLM\SICustom "C:\Users\Default\NTUSER.DAT"

#reg query Themes
reg Query "HKEY_LOCAL_MACHINE\SICustom\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\RegQueryHKLMBefore.txt -Append
reg Query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\RegQueryHKLMBefore.txt -Append
reg Query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\RegQueryHCUBefore1.txt -Append

#Create Accent registry key
New-Item -Path "HKLM:\SICustom\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Force
    
# Set variables to indicate value and key to set
#$RegistryPath = 'HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -Value "C:\Windows\Resources\Themes\themeB.theme" -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "WallpaperSetFromTheme" -Value "1" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "ColorSetFromTheme" -Value "1" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLighTheme" -Value "0" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUsesLightTheme" -Value "0" -PropertyType DWORD -Force

#Enable accent color on the Taskbar etc..
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value "1" -PropertyType DWORD -Force

#set color
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "StartColorMenu" -Value "0xffc06700" -PropertyType DWORD -Force
New-ItemProperty -Path "HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentColorMenu" -Value "0xffd47800" -PropertyType DWORD -Force

#Using CMD to add HEX Binary color
REG ADD "HKEY_LOCAL_MACHINE\SICustom\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d 99EBFF004CC2FF000091F8000078D4000067C000003E9200001A6800F7630C00 /f

#close registry because I have access denied to unload the hive.
taskkill /f /im regedit.exe

#Unload the hive saving the changes
reg unload HKLM\SICustom

#need to create output
Stop-Transcript
