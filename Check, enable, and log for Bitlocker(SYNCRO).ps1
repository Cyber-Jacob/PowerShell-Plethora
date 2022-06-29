Import-Module $env:SyncroModule
#EncryptionStatus checks whether or not drive is encrypted. Values are: FullyEncrypted , or FullyDecrypted
$encryptionstatus = Get-BitLockerVolume | Select-Object -ExpandProperty VolumeStatus
#tpmstatus checks if a TPM is present. This variable can also look for TPM version
$tpmstatus = Get-Tpm | Select-Object -ExpandProperty TpmPresent

#Looks for Bitlocker Encryption State, if encrypted, saves Key ID and Key to Custom Syncro Fields by name
if ($encryptionstatus -eq "FullyEncrypted"){
    write-host("Bitlocker is already enabled on this device.")
     $key = (Get-BitLockerVolume -MountPoint $OSDrive).KeyProtector|?{$_.KeyProtectorType -eq 'RecoveryPassword'}
     $kpi = [String]$key.KeyProtectorId
     $rec = [string]$key.RecoveryPassword
     Set-Asset-Field -Subdomain $subdomain -Name "Bitlocker_Key_ID" -Value $kpi
     write-host "Set the Bitlocker_Key_ID field value to $kpi"
     Set-Asset-Field -Subdomain $subdomain -Name "Bitlocker_Key" -Value $rec
     write-host "Set the Bitlocker_Key field value to $rec"

} elseif ($tpmstatus -ne 'True'){
    #Looks for TPM State. If TPM isn't detected, writes this so we know why BL didn't start
    write-host("Unable to detect TPM. Failed to start automated Bitlocker encryption. Did you run as Admin?")
    
}else {
    #Turn on Bitlocker if other conditions don't trigger
    try {
    $ErrorActionPreference = "stop"
    #Enable Bitlocker using TPM
    Enable-Bitlocker -MountPoint $OSDrive -UsedSpaceOnly -TpmProtector -ErrorAction Continue
    Enable-Bitlocker -MountPoint $OSDrive -UsedSpaceOnly -RecoveryPasswordProtector
    
    Start-Sleep -Seconds 30
    $key = (Get-BitLockerVolume -MountPoint $OSDrive).KeyProtector|?{$_.KeyProtectorType -eq 'RecoveryPassword'}
    $kpi = [String]$key.KeyProtectorId
    $rec = [string]$key.RecoveryPassword
    Set-Asset-Field -Subdomain $subdomain -Name "Bitlocker_Key_ID" -Value $kpi
    write-host "Set the BitLocker_Key_ID field value to $kpi"
    Set-Asset-Field -Subdomain $subdomain -Name "Bitlocker_Key" -Value $rec
    write-host "Set the Bitlocker_Key field value to $rec"
    #displays encryption state, if Bitlocker turned on successfully, the value changes from FullyDecrypted, so we check for that
    $encryptionstate= Get-BitLockerVolume | Select-Object -ExpandProperty VolumeStatus
    if ($encryptionstate -ne 'FullyDecrypted'){
    write-host("Bitlocker encryption has initiated.")
    }
    }

catch 
#Error reporting for Syncro
{
    Write-Host "Error Setting up Bitlocker. Make sure to run the cmdlet as an Admin: $_"
    Create-Syncro-Ticket -Subdomain "<SUBDOMAIN>" -Subject "BitLocker Deployment Issue" -IssueType "PC Issue" -Status "New"
}
}
#Verbose text block. This is so we understand what happened with the machine, what it's TPM and encryption state REGARDLESS if Bitlocker successfully started
$encryptionstate= Get-BitLockerVolume | Select-Object -ExpandProperty VolumeStatus
write-host("TPM status is $tpmstatus.")
write-host("Encryption status is currently $encryptionstate")  