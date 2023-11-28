# Managing schema extension
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PS-5.1-blue.svg)]()

In Active Directory you can use a lot of attributes to store information that you can use for specifc needs (identity management, access management, ...).
In Entra ID you have less attributes and it works differently. You don't have only one "schema".
Let see.


## Directory Extension
Entra Connect uses a Directory Extension and External Identities also. 

For External Identities, the name is <b>aad-extensions-app. Do not modify. Used by AAD for storing user data</b>
![image](./images/DirectoryExtension-ExternalIdentities.png)

For Entra Connect, the named is <b>Tenant Schema Extension App</b>.
If you want to get the list of attributes, it's not necessary to connect on Entra Connect. You can use this script: Manage-ExtensionProperty.ps1.
![image](./images/DirectoryExtension-GetAttributes.png)


## Open Extension


## Schema Extension


## Summary 

| Extension type        | Column1           | Stored        | Objects        | Format                               | SSO        |
| -------------------- :| -----------------:| -------------:| --------------:| ------------------------------------:| ----------:|
| Directory Extension   | right-aligned     | Application   | `user`,`group` | Extension_xxxxxxxxx_AttributeName    |            |
| Open Extension        | centered          | Application   |                |         |         |
| Schema Extension      |    $1             | Application   |                |         |         |

### Using the script
List all extensionProperties for default app in Azure AD
```
PS C:\> Manage-ExtensionProperties.ps1 -ListDefaultApp
```

List all extensionProperties for my app in Azure AD
```
PS C:\> Manage-ExtensionProperties.ps1 -ListMyApp -MyAppDisplayName "MyApps"
```

Get all extensionProperties for a specific user
```
PS C:\> Manage-ExtensionProperties.ps1 -Check -UPN "mathias.dumont@contoso.com"
```

Create an extensionProperties in Azure AD
```
PS C:\> Manage-ExtensionProperties.ps1 -Create -MyAppDisplayName "MyApps" -AttributName "UID" -DataType "string" -Object "User"
```

Write an extensionProperties in Azure AD
```
PS C:\> Manage-ExtensionProperties.ps1 -WriteValue -UPN "mathias.dumont@contoso.com"
```

Delete an extensionProperties in Azure AD
```
PS C:\> Manage-ExtensionProperties.ps1 -Delete -MyAppDisplayName "MyApps"
```


# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).