$AccountName = Read-Host("What is the account name")
$HideValue = get-itemproperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList'| Select-Object -ExpandProperty <$AccountName>  

   if ($HideValue)
    {
    echo "<$AccountName> account is unhidden. Hiding it now."
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList' -Name $AccountName -Value 0 -Force
    }
    else 
    {
    echo "<$AccountName> account is hidden. Unhiding it now."
    Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\SpecialAccounts\UserList' -Name $AccountName -Value 1 -Force
    }
    
    
