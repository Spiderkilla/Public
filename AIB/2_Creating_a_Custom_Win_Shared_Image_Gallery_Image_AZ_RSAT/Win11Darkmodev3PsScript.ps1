$date = Get-date -Format yyyyMMddss
Start-Transcript -Append C:\Temp\PSScriptLog$date.txt

#Copy original default user file
#Copy-Item -Path "C:\Users\Default\NTUSER.DAT" -Destination "C:\Users\Default\NTUSER.DAT.OLD"

#Compress-Archive -Path "C:\Users\Default" -DestinationPath "C:\Default$date.zip"

#Load the hive
#reg load HKLM\SICustom "C:\Users\Default\NTUSER.DAT"

#reg query Themes
reg Query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\RegQueryHKLMBefore.txt -Append -Verbose
reg Query "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\RegQueryHKLMBefore.txt -Append -Verbose
reg Query "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes" /s | Out-File -FilePath C:\RegQueryHCUBefore1.txt -Append -Verbose

#Create Accent registry key
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Force -Verbose
New-Item -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Force -Verbose
    
# Set variables to indicate value and key to set
#$RegistryPath = 'HKLM:\SICustom\\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize'
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "CurrentTheme" -Value "C:\Windows\Resources\Themes\themeB.theme" -Force -Verbose
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "WallpaperSetFromTheme" -Value "1" -PropertyType DWORD -Force -Verbose
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes" -Name "ColorSetFromTheme" -Value "1" -PropertyType DWORD -Force -Verbose
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLighTheme" -Value "0" -PropertyType DWORD -Force -Verbose
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUsesLightTheme" -Value "0" -PropertyType DWORD -Force -Verbose

#Enable accent color on the Taskbar etc
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "ColorPrevalence" -Value "1" -PropertyType DWORD -Force -Verbose

#set color
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "StartColorMenu" -Value "0xffc06700" -PropertyType DWORD -Force -Verbose
New-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "AccentColorMenu" -Value "0xffd47800" -PropertyType DWORD -Force -Verbose

#Using CMD to add HEX Binary color
REG ADD "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" /v "AccentPalette" /t REG_BINARY /d 99EBFF004CC2FF000091F8000078D4000067C000003E9200001A6800F7630C00 /f

#close registry because I have access denied to unload the hive.
taskkill /f /im regedit.exe

#Unload the hive saving the changes

[gc]::collect()
Start-Sleep -Seconds 5

#need to create output
Stop-Transcript
