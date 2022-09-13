#List the PSDrives available:: AKA enumerate the Registry, in most cases is HKLM and HKCU
Get-PSDrive -PSProvider registry | select name,root


#Initialize the HKClassesRoot Registry Hive as a PS Drive. This allows us to edit the HKCR path to remove Personal OneDrive
New-PSDrive -PSProvider registry -Root HKEY_CLASSES_ROOT -Name HKCR


start-sleep -Seconds 1


#Get the properties for the OneDrive personal app
$PreSetting = Get-ItemProperty -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}'
echo ($PreSetting)
echo ''

#Set the value to 0 in order to remove OneDrive PErsonal from File Explorer
Set-ItemProperty -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' -Name ("System.IsPinnedToNameSpaceTree") -Value 0 -Force


#initialize an on/off value to verify our operation worked, and then log what the value was set to and whether or not operation was successful
$OneDriveOnOff = Get-ItemProperty -Path 'HKCR:\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}' | Select-Object -ExpandProperty ('System.IsPinnedToNameSpaceTree')
if ($OneDriveOnOff -eq 0)
    {
    stop-process -name explorer -Force
    echo "System.IsPinnedToNameSpaceTree is set to $OneDriveOnOff." 
    echo "OneDrive has been unpinned for this user."
    echo "Explorer Service has been restarted."
   }
elseif ($OneDriveOnOff -eq 1)
    {
    echo "System.IsPinnedToNameSpaceTree is set to $OneDriveOnOff." 
    echo "Registry edit has failed, OneDrive has not been removed."
    }
