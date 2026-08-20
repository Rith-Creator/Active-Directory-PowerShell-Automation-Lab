<#
.SYNOPSIS
    Reports every AD user, their OU, and their group memberships.

.DESCRIPTION
    Pulls all users under the lab.local domain and lists which OU they're
    in and which groups they belong to. Useful for auditing who has access
    to what, and for spotting users who aren't in any group.

.NOTES
    Run on DC01, in an elevated PowerShell window.
#>

$users = Get-ADUser -Filter * -SearchBase "DC=lab,DC=local" -Properties MemberOf

$report = foreach ($user in $users) {
    $ou = ($user.DistinguishedName -split ',', 2)[1]  # everything after the CN
    $groups = if ($user.MemberOf) {
        ($user.MemberOf | ForEach-Object { ($_ -split ',')[0] -replace 'CN=', '' }) -join '; '
    } else {
        "(none)"
    }

    [PSCustomObject]@{
        Name   = $user.Name
        Logon  = $user.SamAccountName
        OU     = $ou
        Groups = $groups
    }
}

$report | Format-Table -AutoSize

# Optional: export to CSV for the README/GitHub
$report | Export-Csv -Path "C:\Users\Administrator\Desktop\group_membership_report.csv" -NoTypeInformation
Write-Host "`nReport also saved to Desktop as group_membership_report.csv" -ForegroundColor Green
