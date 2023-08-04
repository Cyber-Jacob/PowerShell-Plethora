###############################################################################################################################
# Author:        Jacob Schweyer                                                                                               #
# Date:          08/04/2023                                                                                                   #
# Script Name:   M365_MFA_Reset_and_Enable                                                                                    #
# Description:   Reset M365 MFA method and ensure account is reset to Enabled                                                 #
###############################################################################################################################
#Requires an import CSV. This CSV needs to have a column of M365 UPN's, AKA Email Addresses. The column name should be UPN.
#IF the column name is 'email', then change the $user.UPN statements to $user.Email.

$users= (import-csv "Contact List.csv")
$errorUsers = @() #array for users that have errors
$errorMessages = @() #array for error messages from users

try{
  Connect-MSolService
}
catch {
  echo $_.Exception.Message
  echo "`nIssue with Connecting to MSOL Service."
  exit 1 #end script execution with Error if unable to connect.
  }
  
#Create StrongAuth Object to pass with the Set-MSOLUser statement. 
#This must be done to pass the "enabled" state to an M365 user. This ensures they are not 'enforced' with no auth method.

$strongauth = New-Object -TypeName Microsoft.Online.Administration.StrongAuthenticationRequirement
$strongauth.RelyingParty = "*"
$strongauth.State = "Enabled"
$strongauthrequirements = @($strongauth)

#I am leaving this out of a try and catch block, because you may have some emails or UPN's which don't exist in the tenant, 
Foreach ($user in $users) {
  try{
    #reset the method in use
    Reset-MsolStrongAuthenticationMethodByUpn -UserPrincipalName $user.UPN

    #enable MFA
    Set-MSOLUser -UserprincipleName $user.UPN -StrongAuthenticationRequirements $strongauthrequirements
    
}
  catch {
  $error= $_.Exception.Message
  echo "There was a problem with user $user.UPN"
  $errorUsers.Add($user.UPN)
  $errorMessages.Add($error)
  }
}

#Display the users and their errors. This will most likely be due to the email address not existing in the tenant (type or deletion)
for ($counter=0;  $counter -lt $errorUsers.Count; $counter++) {
  echo "`nIssue with User $($errorUsers[$counter]):$errorMessages[$counter]"
  }
