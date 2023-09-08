###########################################################################################################################################
# Author:          Jacob Schweyer                                                                                                         #
# Script Name:     TPM_Version_Number.ps1                                                                                                 #
# Description:     Script to ask hardware for its' TPM version and then write the output/store as a variable for output manipulation      #
#                                                                                                                                         #
# This may be useful if you are upgrading computers in your org, or you have a compliance obligation to log this sort of info. Good luck! #
###########################################################################################################################################

#Set the var for the location we are searching in
$tpmnamespace = "Root\CIMV2\Security\MicrosoftTpm"

#Set the version var to the 1st array object inside of Win32_TPM object inside our namespace. This is the version number.
try{
    $TPMversion = (Get-WmiObject -Namespace $tpmnamespace Win32_TPM).SpecVersion.Split(",")[0] #-as [int]
echo $TPMversion

<# Check for any data in the 1st object before a , in the Win32TPM object inside of our requested namespace. 
If we don't see anything, cry about no TPM. 
You can get null values here when you run as standard user instead of admin. Noted this, since it could mean there is truly no TPM, or you did not run as admin #>
if ($TPMversion -eq $null) {
    echo ("TPM does not appear to be present. Did you run as admin?")
    echo ("")
    $TPMversion = "No TPM Found"
    echo("`n`nTPM Status: `t $TPMVersion `n")
    #Set-Asset-Field -Name "TPM Version" -Value $TPMversion
    }
else {
    echo("TPM Version is: $TPMversion")
    #Set-Asset-Field -Name "TPM Version" -Value $TPMversion
    }
#Set-Asset-Field -Name "TPM Version" -Value $TPMversion
}
catch {
    echo ("An error has occured.")
	exit 1
	}
