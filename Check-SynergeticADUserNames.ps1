# Check-SynergeticADUserNames
# Author: Linus Kay
# 
# Check if user names in Synergetic align with user names in Active Directory
# Takes two .csv files, on for Synergetic users, one for Active Directory users

# import and convert csv files
$synfile = "[SYNERGETIC .CSV FILE LOCATION]"
$adfile = "[AD .CSV FILE LOCATION]"

$adusers = Get-Content $adfile | ConvertFrom-Csv
$synusers = Get-Content $synfile | ConvertFrom-Csv

# loop through all supplied synergetic users
# find matching supplied AD user by ID
# check whether preferred name and surname match respective AD user values
# if no exact name match, report
Write-Output "The following users have non-matching names:"
foreach($user in $synusers) {
    $userMatch = $adusers | Where-Object -Property UserPrincipalName -eq -Value $user.ID
    if(($userMatch -ne $null) -and (($userMatch.givenName -ne $user.Preferred) -or ($userMatch.Surname -ne $user.Surname))) {
        Select-Object (
            @{n='ID';e={$user.ID}},
            @{n='Synergetic Name (Given)';e={$user.Given1 + " " + $user.Surname}},
            @{n='Synergetic Name (Preferred)';e={$user.Preferred + " " + $user.Surname}},
            @{n='AD Name';e={$userMatch.givenName + " " + $userMatch.Surname}}
        ) -InputObject ''
    }
}
