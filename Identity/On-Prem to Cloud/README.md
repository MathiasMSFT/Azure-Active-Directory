# On-Premises to Cloud
In this scenario, we want to migrate our hybrid identity to a cloud identity.

INFO: it's not possible to use MgGraph to do that.

## User objects
It's possible to convert identities to cloud-only.

### Identity info
![image](./images/OnPrem-Informations.png)

### Unsync the user object
Move the user object in Active Directory to an unsynced OU. The user will be deleted in Azure AD.

![image](./images/Unsync-user.png)

### Restore the user in Azure AD
Restore the user in Azure AD

![image](./images/Deleted-user.png)

The user object will be restored

![image](./images/Restored.png)


### Change the UserPrincipalName
It's necessary to change the value of immutableId
```
PS> Set-AzureADUser -ObjectId <objectId> -UserPrincipalName <upn@domain.onmicrosoft.com>
```
![image](./images/Change-UPN.png)


### Set ImmutableId to $null
Change the value of immutableId
```
PS> Get-AzureADuser -SearchString <UserPrincipaName> | Set-Msoluser -ImmutableId $null
```
![image](./images/Set-ImmutableId.png)


### Everything is okay
![image](./images/Cloud-Information.png)


# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).
