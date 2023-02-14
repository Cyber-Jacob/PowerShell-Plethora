###########################################################################################################################################
#Author:           Jacob Schweyer                                                                                                         #
# Script Name:     M365Tenant_MFA_Check_and_Generate_CSVs.ps1                                                                             #
# Description:     Produces reports and CSVs from an M365 environment regarding which users are and are not MFA-enabled or enforced       #
#                  Output is CSV's which can be used immediately* for bulk-updating MFA in the same M365 tenant.                          #
#                                                                                                                                         #
#                                                                                                                                         #
# Permission is hereby granted, free of charge, to any person obtaining a copy of this software who seeks to increase the security        #
# posture of their organization by streamlining or creating an effective process to report on and enforce MFA for large sets of users.    #
# Others are welcome to use this as well, but I'm not sure what use it will be to you. Please let me know, i'd be delighted if this helps #
# even one person or organization                                                                                                         #
###########################################################################################################################################



#connect statement takes a credential and supports modern-auth, use your M365 Tenant Admin to login here
Connect-MsolService


#global count initialization
$GlobalLicenseCount=0 
$globalMFAcount=0
$Global_Licensed_withoutMFA = 0



#Assign the set of the tenant to a variable for parsing. This may not work with very large orgs, so far works alright for up to ~1000 accounts
#and multiple objects/entries per account. This statement is also where you can make parsing statements to limit your selection by Office defined fields
#for example, by "Office" location, or by "Department" name as assigned in O365 Contact information

$tenant_entries = (Get-MSOLUser -All)

#                   (Get-MSOLUser -All | where {$_.Office -eq "Austin"}) ## | where {$_.Department -eq "Sales"}) ##
# Above are some possible example queries to limit the set of the tenant for your parsing variable



#These variables are initialized with tabs and carriage returns, and formatted for output to CSV's, 
#which can be used to Bulk-update MFA information in the M365 tenant

$Global_licensed_mfa_users="Username `t MFA Status `t Office
"
$global_licensed_none_mfa_users="Username `t MFA Status
"
$global_licensed_none_mfa_users_with_office="Username `t MFA Status `t Office
"

#Statement to get all licensed users, so we have a baseline of the rough number we need to enforce MFA for

foreach ($entry in $tenant_entries) {


if ($entry.isLicensed -eq 1) {
$GlobalLicenseCount = $GlobalLicenseCount + 1 
}

if ($entry.isLicensed -eq 1 -And $entry.StrongAuthenticationRequirements.State -eq $null) {
$Global_Licensed_withoutMFA = $Global_Licensed_withoutMFA + 1
$global_licensed_none_mfa_users = $global_licensed_none_mfa_users + $entry.UserPrincipalName + "`t" + $entry.StrongAuthenticationRequirements.State + "
"
$global_licensed_none_mfa_users_with_office=$global_licensed_none_mfa_users_with_office + $entry.UserPrincipalName + "`t" + $entry.StrongAuthenticationRequirements.State + "`t" + $entry.Office + "
"}

if ($entry.isLicensed -eq 1 -And $entry.StrongAuthenticationRequirements.State -ne $null) {
$globalMFAcount = $globalMFAcount + 1
$Global_licensed_mfa_users = $Global_licensed_mfa_users + $entry.UserPrincipalName + "`t" + $entry.StrongAuthenticationRequirements.State + "
"

}

else {
continue
}

} ;

##########################################################################


#This statement outputs to the console an extremely simple and basic report about MFA across the tenant.

echo("Total Licensed Users: $GlobalLicenseCount")
echo("=========================================")
echo("$global_licensed_none_mfa_users")
echo("-----------------------------------------")
echo("Total Licensed Users without MFA: $Global_licensed_withoutMFA")
echo("=========================================")
echo("$Global_licensed_mfa_users")
echo("-----------------------------------------")
echo("Total Licensed Users with MFA enabled or enforced: $globalMFAcount")
echo("=========================================")
echo("Total Licensed Users without MFA: $Global_licensed_withoutMFA")
echo("-----------------------------------------")
echo("Total Licensed Users: $GlobalLicenseCount")

##########################################################################

#This statement generates a CSV of licensed useres enabled or enforced for MFA in the M365 tenant

$Global_licensed_mfa_users | Out-File '<INSERT PATH HERE>\licensed_mfa-users.csv'

##########################################################################

#This statement generates a CSV of licensed users who are not enabled or enforced for MFA in the M365 tenant. This can be used as a Bulk-update CSV with
#minimal editing and some slight CSV/XLSX manipulation knowhow. It would be trivial to change this script to include an update in the MFA Status field
#of "Enabled" so the CSV generated can be used immediately for bulk-updates. I've chosen to exclude that so that the end user of this script has to make some 
#slight changes

$global_licensed_none_mfa_users | Out-File '<INSERT PATH HERE>\licensed_none-MFA-users.csv'

##########################################################################

#This statement generates a CSV of licensed users who are not enabled or enforced and includes the assigned "Office" location for reporting purposes

#$global_licensed_none_mfa_users_with_office | Out-File '<INSERT PATH HERE>\licensed-none-mfa-users-andLocation.csv'

##########################################################################
