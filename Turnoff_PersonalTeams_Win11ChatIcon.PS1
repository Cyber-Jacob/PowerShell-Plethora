####################################################
#Turn Off Chat Icon and Personal Teams - Windows 11#
#Author: RecyclableBag                             #
#Date: 13-02-2023                                  #
####################################################
#Remove personal version of teams, it is installed as an Appx package (the chat icon will reinstall the package if you click it)
Get-AppxPackage -name "microsoftteams" | Remove-AppxPackage -AllUsers
#Remove the Windows 11 chat icon, and by extension the ablity to reinstall personal teams on accident
set-itemproperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Taskbarmn -Value 0
