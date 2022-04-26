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
#   Author: Donovan du Val                                                  #
#   Contributor: Mathias Dumont                                             #
#   Version 1.0         Date Last Modified: 18 October 2021                 #  
#                                                                           #  
#############################################################################  
.SYNOPSIS
    PowerShell Script to extract all roles in PIM

.DESCRIPTION
    The script will generate a report for all roles in the Azure AD Tenant.

.EXAMPLE
    Generates a report in the CSV and HTML format
    PS C:\> Generate-PIM-Report.ps1 -export All

.EXAMPLE
    Generates a report in the CSV format
    PS C:\> Generate-PIM-Report.ps1 -export CSV

.EXAMPLE
    Generates a report in the HTML format
    PS C:\> Generate-PIM-Report.ps1 -export HTML

.NOTES
    This script is based on Donovan du Val script (https://github.com/Donovand4/ConditionalAccessPolicyReport/blob/master/Generate-ConditionalAccessReport.ps1)

.LINK
    Github 
    https://github.com/microsoftgraph/msgraph-sdk-powershell 
    Microsoft Graph PowerShell Module
    https://www.powershellgallery.com/packages/Microsoft.Graph

#>
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0)]
    [ValidateSet("All", "CSV", "HTML")]
    $Export
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
        write-host "Successfully logged into Microsoft Graph" -ForegroundColor Green
    }
}

#Requires -Version 5.1
#Requires -Modules Microsoft.Graph.Authentication, Microsoft.Graph.Identity.DirectoryManagement, Microsoft.Graph.Groups


If (!(Get-MgContext).Account) {
    Write-Host "Not connected" -ForegroundColor Magenta
    MgGraph-Connect
} Else {
    Write-Host "Already logged into Microsoft Graph" -ForegroundColor Green
    
}

$Date = Get-Date -format dd-MMMM-yyyy
$Filename = "PIM-Report - $($Date)"

$Head = @"  
<style>
header {
    text-align: center;
    }
    body {
    font-family: "Arial";
    font-size: 10pt;
    color: #4C607B;
    }
    table, th, td {
        width: 450px;
    border-collapse: collapse;
    border: solid;
    border: 1.5px solid black;
    padding: 3px;
    }
    th {
    font-size: 1.2em;
    text-align: center;
    background-color: #003366;
    color: #ffffff;
    }
    td {
    color: #000000;    
    }
    tr:nth-child(even) {background-color: #d6d6d6;}
</style>  
"@


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
                $GroupDisplayName = $($_.AdditionalProperties.displayName)
                $GroupDisplayName = $GroupDisplayName.Replace("'","''")
                $Members = ((Get-MgGroupMember -GroupId ((Get-MgGroup  -Filter "DisplayName eq '$GroupDisplayName'").Id)).AdditionalProperties.userPrincipalName) -join ","
                $AllMembers += $Members
            }
        })
        "MemberOfGroup" = $AllMembers -join ","
    }
}



Write-host "Creating the Reports." -ForegroundColor Green
$ReportData = $Report | Select-Object -Property Displayname,Description,RoleTemplateId,ID,DirectMemberDisplayname,DirectMemberUPN,MemberOfGroup | Sort-Object -Property Displayname
Write-Host "" 
switch ($Export) {
    "All" { 
        Write-host "Generating the HTML Report." -ForegroundColor Green
        $ReportData | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h1><center>Privileged Identity Management Report - $Date</center></h1></font>" | Out-File "$Filename.html"
        
        Write-host "Generating the CSV Report." -ForegroundColor Green
        $ReportData | Export-Csv "$Filename.csv" -NoTypeInformation 
    }
    "CSV" {
        Write-host "Generating the CSV Report." -ForegroundColor Green
        $ReportData | Export-Csv "$Filename.csv" -NoTypeInformation
    }
    "HTML" {
        Write-host "Generating the HTML Report." -ForegroundColor Green
        $ReportData | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h1><center>Privileged Identity Management Report - $Date</center></h1></font>" | Out-File "$Filename.html"
    }
}
Write-Host ""
write-host "Disconnecting from Microsoft Graph" -ForegroundColor Green

Disconnect-MGGraph
