<#
.SYNOPSIS
    The script can create attribut, read/modify the value for a specific user and delete an attribute

.DESCRIPTION
    This script requires AzureAD module

.EXAMPLE
    # List all extensionProperties for default app in Azure AD
    PS C:\> Manage-ExtensionProperties.ps1 -ListDefaultApp
    
.EXAMPLE
    # List all extensionProperties for my app in Azure AD
    PS C:\> Manage-ExtensionProperties.ps1 -ListMyApp -MyAppDisplayName "MyApps"

.EXAMPLE
    # Get all extensionProperties for a specific user
    PS C:\> Manage-ExtensionProperties.ps1 -Check -UPN "mathias.dumont@contoso.com"

.EXAMPLE
    # Create an extensionProperties in Azure AD
    PS C:\> Manage-ExtensionProperties.ps1 -Create -MyAppDisplayName "MyApps" -AttributName "UID" -DataType "string" -Object "User"

.EXAMPLE
    # Write an extensionProperties in Azure AD
    PS C:\> Manage-ExtensionProperties.ps1 -WriteValue -UPN "mathias.dumont@contoso.com"

.EXAMPLE
    # Delete an extensionProperties in Azure AD
    PS C:\> Manage-ExtensionProperties.ps1 -Delete -MyAppDisplayName "MyApps"

.NOTES

#>
Param(
    [Switch]$ListDefaultApp,
    [Switch]$ListMyApp,
    [Switch]$Create,
    [Switch]$WriteValue,
    [Switch]$Check,
    [Switch]$DeleteExtensionProperty,
    [Parameter(Mandatory=$false)][string]$AttributName,
    [Parameter(Mandatory=$false)][string]$DataType,
    [Parameter(Mandatory=$false)][string]$Object,
    [Parameter(Mandatory=$false)][string]$Description,
    [Parameter(Mandatory=$false)][string]$UPN,
    [Parameter(Mandatory=$false)][string]$MyAppDisplayName,
    [Parameter(Mandatory=$false)][string]$GrpName
)

Function DefaultApp {
    Write-Host "Find the ObjectID of Tenant Schema Extension App in Azure AD :" -ForegroundColor Green
    $ObjectId = (Get-AzureADApplication -Filter "DisplayName eq 'Tenant Schema Extension App'").ObjectId
    If ($ObjectID) {
        Write-Host "   AppID found : $ObjectId" -ForegroundColor Green
        Get-AzureADApplicationExtensionProperty -ObjectId $ObjectId  
    } Else {
        Write-Host "   AppID not found : $Error" -ForegroundColor Red
    }
    $Error.Clear()
    Write-Host ""
}

Function FindAppID {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $MyAppDisplayName
    )
    Write-Host "Find the ObjectID of $MyAppDisplayName in Azure AD :" -ForegroundColor Green
    $ObjectId = (Get-AzureADApplication -Filter "DisplayName eq '$MyAppDisplayName'").ObjectId
    If ($ObjectID) {
        Write-Host "   AppID found : $ObjectId" -ForegroundColor Green
    } Else {
        Write-Host "   AppID not found : $Error" -ForegroundColor Red
    }
    $Error.Clear()
    Write-Host ""
    Return $ObjectId
}

Function ListextensionProperties {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ObjectId
    )
    ## List All extended properties
    Get-AzureADApplicationExtensionProperty -ObjectId $ObjectId  
}

Function Create {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ObjectId
    )
    ## Create the new attribut
    If ($AttributName) { 
        New-AzureADApplicationExtensionProperty -ObjectId $ObjectId -Name $AttributName -DataType $DataType -TargetObjects $Object #-ErrorAction SilentlyContinue
        $ExtensionProperties = Get-AzureADApplicationExtensionProperty -ObjectId $ObjectId | Where {$_.Name -like "*$attributName"}
        Write-Host "   $ExtensionProperties" -Foregroundcolor Green
    } Else {
        Write-Host "   You don't enter parameter so you have to use this command (Manage-ExtensionProperties-AzureAD.ps1 -Create -AttributName '' -DataType '' -Object '' -Description ''" -ForegroundColor Magenta

    }
}

Function WriteValuee {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $UPN
    )
    ## Set a value for an user
    $extPropertyName = Read-Host 'Enter the name of the extensionProperty (extension_xxxxxx_UID)'
    $Value = Read-Host 'Enter the value'
    $UserId = (Get-AzureADUser -Filter "userPrincipalName eq '$UPN'").ObjectId
    Set-AzureADUserExtension -ObjectId $UserId -ExtensionName $extPropertyName -ExtensionValue $Value # -Description $Description

    ## List extensionProperty for an user
    Write-Host "Get user info" -ForegroundColor Yellow
    Get-AzureADUser -ObjectId $UPN | select -ExpandProperty extensionProperty
}

Function WriteValue {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $GrpName
    )
    ## Set a value for an user
    $extPropertyName = Read-Host 'Enter the name of the extensionProperty (extension_xxxxxx_UID)'
    $Value = Read-Host 'Enter the value'
    $GroupId = (Get-AzureADGroup -Filter "displayName eq '$GrpName'").ObjectId
    Set-AzureADGroupExtension -ObjectId $GroupId -ExtensionName $extPropertyName -ExtensionValue $Value # -Description $Description

    ## List extensionProperty for an user
    Write-Host "Get user info" -ForegroundColor Yellow
    Get-AzureADGroup -ObjectId $UPN | select -ExpandProperty extensionProperty
}


Function Check {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $UPN
    )
    ## List extensionProperty for an user
    Get-AzureADUser -ObjectId $UPN | select -ExpandProperty extensionProperty
}

Function DeleteExtensionProperty {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ObjectId
    )
    $AttributeName = Read-Host 'Enter the name of the extensionProperty (extension_xxxxxx_UID)'
    $ExtensionID = (Get-AzureADApplicationExtensionProperty -ObjectId $ObjectId -ErrorAction SilentlyContinue | where {$_.Name -eq $AttributeName}).ObjectID
    Remove-AzureADApplicationExtensionProperty -ObjectId $ObjectId -ExtensionPropertyId $ExtensionID -ErrorAction SilentlyContinue
    ListextensionProperties -ObjectID $ObjectId
}


## Connect to Azure AD
# Connect-AzureAD

$Parameter = $MyInvocation.BoundParameters.Keys
Switch ($Parameter) {
    "ListDefaultApp" {
        Write-Host "List all extensionProperties of default application" -ForegroundColor Yellow
        DefaultApp
    }
    "ListMyApp" {
        Write-Host "List all extensionProperties of my application" -ForegroundColor Yellow
        $ObjectId = FindAppID -MyAppDisplayName $MyAppDisplayName
        ListextensionProperties -ObjectID $ObjectId
    }
    "Create" {
        Write-Host "Create an extensionProperties" -ForegroundColor Yellow
        $ObjectId = FindAppID -MyAppDisplayName $MyAppDisplayName
        Create -ObjectId $ObjectId
    }
    "WriteValue" {
        Write-Host "Write a value on an extensionProperties of a specific user" -ForegroundColor Yellow
        # WriteValue -UPN $UPN
        WriteValue -GrpName $GrpName
    }

    "DeleteExtensionProperty" {
        Write-Host "Delete an extensionProperty" -ForegroundColor Yellow
        $ObjectId = FindAppID -MyAppDisplayName $MyAppDisplayName
        DeleteExtensionProperty -ObjectId $ObjectId
    }
    "Check" {
        Write-Host "Check for a specific user" -ForegroundColor Yellow
        Check -UPN $UPN
    }
    default {
    }
}

