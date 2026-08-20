# Active Directory & PowerShell Automation Lab

A self-contained corporate network environment built from scratch to practice core IT/sysadmin skills: Active Directory, Group Policy, and PowerShell automation.

## Overview

This lab simulates a small company's IT infrastructure — a domain controller managing user accounts across three departments, security policies enforced automatically across the network, and PowerShell scripts for common administrative tasks.

**Environment:**
- Host: Windows 10/11, 32GB RAM
- Hypervisor: Oracle VirtualBox, custom NAT Network for internal VM connectivity + internet access
- Domain Controller (`DC01`): Windows Server 2025 Standard (Desktop Experience), 4GB RAM, 2 vCPU, 60GB disk
- Client (`CLIENT01`): Windows 11 Enterprise Evaluation, 4GB RAM, 2 vCPU, 60GB disk
- Domain: `lab.local`

## What's included

### Active Directory
- Domain controller promoted and running `lab.local`
- Static IP (10.0.2.15) configured on the DC so client machines can reliably locate it
- 3 Organizational Units: **IT**, **Sales**, **HR**
- 12 user accounts distributed across the OUs

### Group Policy
Three GPOs were created and linked, each demonstrating a different policy category:

| GPO | Linked to | Setting | Purpose |
|---|---|---|---|
| `IT-Password-Policy` | IT OU | Minimum password length: 10 characters | Account security baseline |
| `Sales-Desktop-Restrictions` | Sales OU | Prevent changing desktop background | UI/configuration lockdown |
| `HR-Screen-Lock-Timeout` | HR OU | Screen saver enabled, password-protected, 10-minute timeout | Idle session security |

**Verified working end-to-end:** logged into `CLIENT01` (domain-joined) as a Sales user and confirmed the desktop background setting was blocked with a "Some of these settings are managed by your organization" message — proof the policy chain (AD → OU → GPO → client enforcement) functions correctly.

### Client domain join
`CLIENT01` was joined to `lab.local`. Along the way, this surfaced a real troubleshooting scenario: the client couldn't locate the domain because it was using public ISP DNS servers instead of the domain controller. Diagnosed using `ping` and `nslookup`, resolved by manually setting the client's DNS server to the DC's static IP.

### PowerShell scripts

| Script | Purpose |
|---|---|
| `Get-GroupMembershipReport.ps1` | Lists every AD user, their OU, and group memberships. Exports to CSV. |
| `Toggle-OUAccounts.ps1` | Bulk-enables or bulk-disables every account in a given OU (department restructuring, offboarding, incident response scenarios). |
| `Get-LoginAuditReport.ps1` | Pulls successful and failed logon events from the Security event log — a lightweight audit tool, and a natural bridge into SIEM-style log analysis. |
| `Create-LabUsers.ps1` | Bulk-creates AD users from a CSV, sorted into their OU automatically. |

`lab_users.csv` — the sample user data used with `Create-LabUsers.ps1`.

## Skills demonstrated

- Active Directory Domain Services: installation, promotion, domain/forest configuration
- Organizational Unit design and user account management
- Group Policy Object creation, linking, and enforcement verification
- Network troubleshooting: DNS resolution, connectivity testing (ping/nslookup)
- PowerShell scripting for AD administration and log auditing
- VirtualBox networking (NAT Network configuration, static IP assignment)

## Notes

This is a lab/learning environment, not a production deployment — passwords and configurations here are intentionally simplified for demonstration purposes and would not reflect production security practices.
