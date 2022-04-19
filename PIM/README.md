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

### Credits
Donovan Du Val / Mathias Dumont


## Get-Roles-In-PIM
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

### Credits
Mathias Dumont