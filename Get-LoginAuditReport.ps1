<#
.SYNOPSIS
    Audits recent logon activity from the Security event log.

.DESCRIPTION
    Pulls recent successful (Event ID 4624) and failed (Event ID 4625)
    logon attempts from DC01's Security log. This is a lightweight version
    of what a SIEM dashboard would show, and doubles as a natural bridge
    into the SIEM/log-analysis project if you build that next.

.NOTES
    Run on DC01, in an elevated PowerShell window.
    Requires the Security log to actually have entries -- log in/out a
    few times on CLIENT01 first, or try a deliberate wrong password once
    to generate a failed-logon event to see in the report.
#>

$Hours = 24  # how far back to look

$startTime = (Get-Date).AddHours(-$Hours)

Write-Host "=== Successful Logons (Event ID 4624) - last $Hours hours ===" -ForegroundColor Green
Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4624
    StartTime = $startTime
} -ErrorAction SilentlyContinue |
    Select-Object TimeCreated,
        @{N='Account';E={$_.Properties[5].Value}},
        @{N='SourceIP';E={$_.Properties[18].Value}} |
    Where-Object { $_.Account -notmatch '\$$' } |  # filter out machine accounts
    Format-Table -AutoSize

Write-Host "`n=== Failed Logons (Event ID 4625) - last $Hours hours ===" -ForegroundColor Red
Get-WinEvent -FilterHashtable @{
    LogName   = 'Security'
    Id        = 4625
    StartTime = $startTime
} -ErrorAction SilentlyContinue |
    Select-Object TimeCreated,
        @{N='Account';E={$_.Properties[5].Value}},
        @{N='SourceIP';E={$_.Properties[19].Value}} |
    Format-Table -AutoSize

Write-Host "`nIf both sections are empty, no logon events were recorded in the last $Hours hours yet -- try logging into CLIENT01 a couple times first, then re-run."
