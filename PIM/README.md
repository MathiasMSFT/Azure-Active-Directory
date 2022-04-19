# Privilege Identity Management
All of these scripts will help you to manage PIM in Azure Active Directory

## Generate-PIM-Report
### Project Goals
- Generate a report of all PIM roles.

### Current Version
- Version: 1.0

### History
- Oct 18, 2021 : Contribution

### Using the script
PS> Generate-PIM-Report.ps1 -Export CSV


## Get-Roles-In-PIM
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PS-5.1-blue.svg)]()
<a href="https://twitter.com/shodanhq"><img src="https://img.shields.io/twitter/follow/mathias_dumont.svg?logo=twitter"></a>
### Project Goals
- Find roles assigned to a user or a Privileged Access Group.

### Current Version
- Version: 1.0

### History
- April 19, 2022 : Contribution

### Using the script
PS> Get-Roles-In-PIM.ps1 -User myuser@contoso.com

### Using the script
PS> Get-Roles-In-PIM.ps1 -PAG nameofmygroup

### Screenshot
![image](https://user-images.githubusercontent.com/94542446/164080499-f5784838-cc6f-452c-9f95-60679c844605.png)
