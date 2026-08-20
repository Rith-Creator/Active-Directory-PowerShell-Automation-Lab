<#
.SYNOPSIS
    Bulk-disables or bulk-enables every user account in a given OU.

.DESCRIPTION
    Real-world use case: an employee's department gets restructured, a
    contractor's engagement ends, or IT needs to lock out an entire OU
    during an incident. This script does it in bulk instead of clicking
    through each account individually.

.NOTES
    Run on DC01, in an elevated PowerShell window.
    Edit $TargetOU and $Action below before running.
#>

# --- Configuration ---
$TargetOU = "OU=Sales,DC=lab,DC=local"   # change to IT / HR / Sales as needed
$Action   = "Disable"                     # "Disable" or "Enable"

# --- Get the users in that OU ---
$users = Get-ADUser -Filter * -SearchBase $TargetOU

if ($users.Count -eq 0) {
    Write-Host "No users found in $TargetOU" -ForegroundColor Yellow
    exit
}

foreach ($user in $users) {
    if ($Action -eq "Disable") {
        Disable-ADAccount -Identity $user
        Write-Host "Disabled: $($user.Name)" -ForegroundColor Red
    }
    elseif ($Action -eq "Enable") {
        Enable-ADAccount -Identity $user
        Write-Host "Enabled: $($user.Name)" -ForegroundColor Green
    }
}

Write-Host "`nDone. $($users.Count) account(s) processed in $TargetOU."

# Verify with: Get-ADUser -Filter * -SearchBase "$TargetOU" -Properties Enabled | Select Name,Enabled
