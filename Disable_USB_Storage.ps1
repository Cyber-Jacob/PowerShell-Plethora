###########################################################################################################################################
# Author:           Jacob Schweyer                                                                                                        #
# Script Name:     Disable_USB_Storage.ps1                                                                                                #
# Description:     Disables USB storage for windows machines, while keeping other functionalist intact.                                   #
###########################################################################################################################################

try {
$StartValue = [int](Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" | Select-Object -expandProperty Start)
if ($StartValue -ne 4) {
    Write-Host "Disabling USB storage on this device."
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" -Value 4
   }
$testValue = [int](Get-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\USBSTOR" -Name "Start" | Select-Object -expandProperty Start)


switch ($testvalue)
{
    4 {"USB Storage has been disabled." ; Break}
    Default {
        "Failed to disable USB Storage" ; exit 1
    }    
}


}

catch {
    echo ("An error has occured.")
    exit 1
	}
