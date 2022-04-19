<#
#############################################################################  
#                                                                           #  
#   This Sample Code is provided for the purpose of illustration only       #  
#   and is not intended to be used in a production environment.  THIS       #  
#   SAMPLE CODE AND ANY RELATED INFORMATION ARE PROVIDED "AS IS" WITHOUT    #  
#   WARRANTY OF ANY KIND, EITHER EXPRESSED OR IMPLIED, INCLUDING BUT NOT    #  
#   LIMITED TO THE IMPLIED WARRANTIES OF MERCHANTABILITY AND/OR FITNESS     #  
#   FOR A PARTICULAR PURPOSE.  We grant You a nonexclusive, royalty-free    #  
#   right to use and modify the Sample Code and to reproduce and distribute #  
#   the object code form of the Sample Code, provided that You agree:       #  
#   (i) to not use Our name, logo, or trademarks to market Your software    #  
#   product in which the Sample Code is embedded; (ii) to include a valid   #  
#   copyright notice on Your software product in which the Sample Code is   #  
#   embedded; and (iii) to indemnify, hold harmless, and defend Us and      #  
#   Our suppliers from and against any claims or lawsuits, including        #  
#   attorneys' fees, that arise or result from the use or distribution      #  
#   of the Sample Code.                                                     # 
#                                                                           # 
#   This posting is provided "AS IS" with no warranties, and confers        # 
#   no rights. Use of included script samples are subject to the terms      # 
#   specified at https://www.microsoft.com/info/copyright.htm.              # 
#                                                                           #
#   Author: Mathias Dumont                                                  #
#   Version 1.0         Date Last Modified: 19 April 2022                   #  
#                                                                           #  
#############################################################################  
.SYNOPSIS
    PowerShell Script to extract roles in PIM based on specific information

.DESCRIPTION
    The script shows you the roles of a specific user or PAG (Privileged Access Group).

.EXAMPLE
    List roles based on UPN of user
    PS C:\> Get-Roles-In-PIM.ps1 -User "myuser@contoso.com"

.EXAMPLE
    List roles based on name of PAG
    PS C:\> Get-Roles-In-PIM.ps1 -PAG "Name of group"

.NOTES

.LINK
    Github 
    https://github.com/microsoftgraph/msgraph-sdk-powershell 
    Microsoft Graph PowerShell Module
    https://www.powershellgallery.com/packages/Microsoft.Graph

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$false, Position=0)]
    $PAG,
    [Parameter(Mandatory=$false, Position=1)]
    $User
)

Function MgGraph-Connect {
    write-host "Importing the modules..."
    Import-Module Microsoft.Graph.Authentication, Microsoft.Graph.Identity.DirectoryManagement, Microsoft.Graph.Groups

    write-host "Logging into Microsoft Graph" -ForegroundColor Green

    if ((Connect-MGGraph -Scopes "Directory.Read.All") -eq $null) 
    {
        write-host "Login Failed. Exiting......." -ForegroundColor Red
        sleep -Seconds 2
        Exit
    } 
    else 
    {
        write-host "Successfully Logged into Microsoft Graph" -ForegroundColor Green
    }
}

Function Get-Data {
    $Report = @()
    ## Collects the roles using the MgDirectoryRole command.
    foreach ($Role in (Get-MgDirectoryRole)) {
        $RoleMember = Get-MgDirectoryRoleMember -DirectoryRoleId $($Role.id) 
        $AllMembers = @()
        ## Create report
        $Report += New-Object PSobject -Property @{
            "Displayname"  = $Role.displayName
            "Description"  = $Role.Description
            "RoleTemplateId" = $Role.RoleTemplateId
            "ID"  = $Role.id
            "DirectMemberDisplayname" = if ($RoleMember.AdditionalProperties.displayName){($RoleMember | ForEach-Object{$_.AdditionalProperties.displayName}) -join ","} else {"Null"}     
            "DirectMemberUPN" = if ($RoleMember.AdditionalProperties.userPrincipalName){($RoleMember | ForEach-Object{$_.AdditionalProperties.userPrincipalName}) -join ","} else {"Null"}
            $AllMembers = ($RoleMember | ForEach-Object{
                if ($_.AdditionalProperties.'@odata.type' -eq "#microsoft.graph.group") {
                    $Members = ((Get-MgGroupMember -GroupId ((Get-MgGroup  -Filter "DisplayName eq '$($_.AdditionalProperties.displayName)'").Id)).AdditionalProperties.userPrincipalName) -join ","
                    $AllMembers += $Members
                }
            })
            "MemberOfGroup" = $AllMembers -join ","
        }
    }
    Return $Report
}

#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Identity.DirectoryManagement, Microsoft.Graph.Groups

If ((!($User)) -and (!($PAG))) {
    Write-Host "No parameter !!!" -ForegroundColor Red
} Else {
    MgGraph-Connect

    $Report = Get-Data

    If ($User){
        # Search based on UPN (direct member)
        Write-Host "Role(s) found based on UPN in direct member" -ForegroundColor Yellow
        $DirectMembers = $Report.Where({$($_.DirectMemberUPN) -match "$User"})
        $DirectMembers.Displayname
        # Search based on UPN (group membership)
        Write-Host "Role(s) found based on UPN in group membership" -ForegroundColor Yellow
        $GroupMembers = $Report.Where({$($_.MemberOfGroup) -match "$User"})
        $GroupMembers.DisplayName
    }
    If ($PAG) {
        # Search based on PAG in direct member column
        Write-Host "Role(s) found based on PAG" -ForegroundColor Yellow
        $Roles = $Report.Where({$($_.DirectMemberDisplayname) -match "$PAG"})
        $Roles.Displayname
    }

    Disconnect-MGGraph
}