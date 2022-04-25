# Identity
All of these scripts will help you to manage PIM in Azure Active Directory

## Service Principal
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PS-5.1-blue.svg)]()
### Project Goals
- Create an application with a certificate.

### Current Version
- Version: 1.0

### History
- April 24, 2022 : Contribution

### Using the script
PS> Create-ServicePrincipal.ps1 -AppName "SP-AzureAD" -SelfSigned "Yes"

### Using the script
PS> Create-ServicePrincipal.ps1 -AppName "SP-AzureAD" -SelfSigned "No" -Certificate "C:\<mycertificate>.cer"

### Screenshot



# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).