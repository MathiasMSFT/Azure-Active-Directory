<#
.SYNOPSIS

.DESCRIPTION

.EXAMPLE

.EXAMPLE

.EXAMPLE

.INPUTS

.OUTPUTS

.NOTES

.LINK

#>
[CmdletBinding()]
Param (
    [Switch]$Applications,
    [Switch]$ServicePrincipal,
    [Parameter(Mandatory=$false, Position=0)]
    [ValidateSet("All", "CSV", "HTML")]
    $ExportFile
  )
Function GetApplications {
    $Filename = "ApplicationsReport - $($Date)"
    $AppReport = @()
    ## Get all Application
    ForEach ($Application in $(Get-MgApplication)){
        Write-Host $($Application.DisplayName) -ForegroundColor Yellow

        $spOAuth2PermissionsGrants = (Get-MgServicePrincipal -Filter "AppId eq '$($Application.AppId)'").Oauth2PermissionGrants

        $AppReport += New-Object PSobject -Property @{
            "Displayname"  = if ($Application.DisplayName){$Application.DisplayName}Else{"Not Configured"}
            "Description"  = if ($Application.Description){$Application.Description}Else{"Not Configured"}
            "Owners" = if ($Application.Owners){$Application.Owners}Else{"Not Configured"}
            "ID"  = if ($Application.Id){$Application.Id}Else{"Not Configured"}
            "ApplicationTemplateId" = if ($Application.ApplicationTemplateId){$Application.ApplicationTemplateId}Else{"Not Configured"}
            "CreatedDateTime" = if ($Application.CreatedDateTime){$Application.CreatedDateTime}Else{"Not Configured"}
            "SignInAudience" = if ($Application.SignInAudience){$Application.SignInAudience}Else{"Not Configured"}
            "AppId"  = if ($Application.AppId){$Application.AppId}Else{"Not Configured"}
            "AppRoles" = if ($Application.AppRoles.DisplayName){$Application.AppRoles.DisplayName -join ","}Else{"Not Configured"}
            "AppRolesOrigin" = if ($Application.AppRoles.Origin){$Application.AppRoles.Origin -join ","}Else{"Not Configured"}
            "AppRolesIsEnabled" = if ($Application.AppRoles.IsEnabled){$Application.AppRoles.IsEnabled -join ","}Else{"Not Configured"}
            "ServicePrincipal" = if (Get-MgServicePrincipal -Filter "AppId eq '$($Application.AppId)'"){$(Get-MgServicePrincipal -Filter "AppId eq '$($Application.AppId)'").Id -join ","}Else{"No Service Principal"}
            "IdentifiersUris" = if ($Application.IdentifierUris){$Application.IdentifierUris -join ","}Else{"Not Configured"}
            "WebHomePageUrl" = if ($Application.Web.HomePageUrl){$Application.Web.HomePageUrl -join ","}Else{"Not Configured"}
            "WebLogoutUrl" = if ($Application.Web.LogoutUrl){$Application.Web.LogoutUrl -join ","}Else{"Not Configured"}
            "WebRedirectUris" = if ($Application.Web.RedirectUris){$Application.Web.RedirectUris -join ","}Else{"Not Configured"}
            "HomeRealmDiscoveryPolicies" = if ($Application.HomeRealmDiscoveryPolicies){$Application.HomeRealmDiscoveryPolicies}Else{"Not Configured"}
            "PublisherDomain" = if ($Application.PublisherDomain){$Application.PublisherDomain}Else{"Not Configured"}
            "VPAddedDateTime" = if ($Application.VerifiedPublisher.AddedDateTime){$Application.VerifiedPublisher.AddedDateTime}Else{"Not Configured"}
            "VPDisplayName" = if ($Application.VerifiedPublisher.DisplayName){$Application.VerifiedPublisher.DisplayName}Else{"Not Configured"}
            "VerifiedPublisherId" = if ($Application.VerifiedPublisher.VerifiedPublisherId){$Application.VerifiedPublisher.VerifiedPublisherId}Else{"Not Configured"}
            "ExtensionProperties" = if ($Application.ExtensionProperties){$Application.ExtensionProperties}Else{"Not Configured"}
            "AddPropKey" = if ($Application.AdditionalProperties.Keys){$Application.AdditionalProperties.Keys -join ","}Else{"Not Configured"}
            "AddPropValue" = if ($Application.AdditionalProperties.Value){$Application.AdditionalProperties.Value -join ","}Else{"Not Configured"}
            "GroupMembershipClaims" = if ($Application.GroupMembershipClaims){$Application.GroupMembershipClaims}Else{"Not Configured"}
            "OptClaimsAccessToken" = if ($Application.OptionalClaims.AccessToken.Name){$Application.OptionalClaims.AccessToken.Name -join ","}Else{"Not Configured"}
            "OptClaimsIdToken" = if ($Application.OptionalClaims.IdToken.Name){$Application.OptionalClaims.IdToken.Name -join ","}Else{"Not Configured"}
            "OptClaimsSaml2Token" = if ($Application.OptionalClaims.Saml2Token.Name){$Application.OptionalClaims.Saml2Token.Name -join ","}Else{"Not Configured"}
            "OptClaimsAdditionalProperties" = if ($Application.OptionalClaims.AdditionalProperties){$Application.OptionalClaims.AdditionalProperties -join ","}Else{"Not Configured"}
            "InfoLogoUrl" = if ($Application.Info.LogoUrl){$Application.Info.LogoUrl}Else{"Not Configured"}
            "InfoMarketingUrl" = if ($Application.Info.MarketingUrl){$Application.Info.MarketingUrl -join ","}Else{"Not Configured"}
            "InfoPrivacyStatementUrl" = if ($Application.Info.PrivacyStatementUrl){$Application.Info.PrivacyStatementUrl -join ","}Else{"Not Configured"}
            "InfoSupportUrl" = if ($Application.Info.SupportUrl){$Application.Info.SupportUrl -join ","}Else{"Not Configured"}
            "InfoTermsOfServiceUrl" = if ($Application.Info.TermsOfServiceUrl){$Application.Info.TermsOfServiceUrl -join ","}Else{"Not Configured"}
            "Logo" = if ($Application.Logo){$Application.Logo}Else{"Not Configured"}
            "Notes" = if ($Application.Notes){$Application.Notes}Else{"Not Configured"}
            "PubCltRedirectUris" = if ($Application.PublicClient.RedirectUris){$Application.PublicClient.RedirectUris -join ","}Else{"Not Configured"}
            "RequiredResourceAccessId" = if ($Application.RequiredResourceAccess.ResourceAppId){$Application.RequiredResourceAccess.ResourceAppId -join ","}Else{"Not Configured"}
            "Oauth2RequirePostResponse" = if ($Application.Oauth2RequirePostResponse){$Application.Oauth2RequirePostResponse}Else{"Not Configured"}
            "PassCredDisplayName" = if ($Application.PasswordCredentials.DisplayName){$Application.PasswordCredentials.DisplayName -join ","}Else{"Not Configured"}
            "PassCredId" = if ($Application.PasswordCredentials.KeyId){$Application.PasswordCredentials.KeyId -join ","}Else{"Not Configured"}
            "PassCred" = if ($Application.PasswordCredentials.EndDateTime){$Application.PasswordCredentials.EndDateTime -join ","}Else{"Not Configured"}
            "KeyCredDisplayName" = if ($Application.KeyCredentials.DisplayName){$Application.KeyCredentials.DisplayName -join ","}Else{"Not Configured"}
            "KeyCredId" = if ($Application.KeyCredentials.KeyId){$Application.KeyCredentials.KeyId -join ","}Else{"Not Configured"}
            "KeyCredEndDateTime" = if ($Application.KeyCredentials.EndDateTime){$Application.KeyCredentials.EndDateTime -join ","}Else{"Not Configured"}
            "TokenEncryptionKeyId" = if ($Application.TokenEncryptionKeyId){$Application.TokenEncryptionKeyId}Else{"Not Configured"}
            "TokenIssuancePolicies" = if ($Application.TokenIssuancePolicies){$Application.TokenIssuancePolicies}Else{"Not Configured"}
            "TokenLifetimePolicies" = if ($Application.TokenLifetimePolicies){$Application.TokenLifetimePolicies}Else{"Not Configured"}
            "IsDeviceOnlyAuthSupported" = if ($Application.IsDeviceOnlyAuthSupported){$Application.IsDeviceOnlyAuthSupported}Else{"Not Configured"}
            "ParentalCtlCountriesBlockedForMinors" = if ($Application.ParentalControlSettings.CountriesBlockedForMinors){$Application.ParentalControlSettings.CountriesBlockedForMinors -join ","}Else{"Not Configured"}
            "ParentalCtlLegalAgeGroupRule" = if ($Application.ParentalControlSettings.LegalAgeGroupRule){$Application.ParentalControlSettings.LegalAgeGroupRule -join ","}Else{"Not Configured"}
            "Tags" = if ($Application.Tags){$Application.Tags -join ","}Else{"Not Configured"}
            "SpaRedirectUris" = if ($Application.Spa.RedirectUris){$Application.Spa.RedirectUris -join ","}Else{"Not Configured"}
            "AddIns" = if ($Application.AddIns){$Application.AddIns -join ","}Else{"Not Configured"}
            "ApiAcceptMappedClaims" = if ($Application.Api.AcceptMappedClaims){$Application.Api.AcceptMappedClaims -join ","}Else{"Not Configured"}
            "ApiKnownClientApplications" = if ($Application.Api.KnownClientApplications){$Application.Api.KnownClientApplications -join ","}Else{"Not Configured"}
            "ApiRequestedAccessTokenVersion" = if ($Application.Api.RequestedAccessTokenVersion){$Application.Api.RequestedAccessTokenVersion -join ","}Else{"Not Configured"}
            "COBOfId" = if ($Application.CreatedOnBehalfOf.Id){$Application.CreatedOnBehalfOf.Id -join ","}Else{"Not Configured"}
            "COBOfDeletedDateTime" = if ($Application.CreatedOnBehalfOf.DeletedDateTime){$Application.CreatedOnBehalfOf.DeletedDateTime -join ","}Else{"Not Configured"}
            "DeletedDateTime" = if ($Application.DeletedDateTime){$Application.DeletedDateTime}Else{"Not Configured"}
            "DisabledByMicrosoftStatus" = if ($Application.DisabledByMicrosoftStatus){$Application.DisabledByMicrosoftStatus}Else{"Not Configured"}
            "IsFallbackPublicClient" = if ($Application.IsFallbackPublicClient){$Application.IsFallbackPublicClient}Else{"Not Configured"}
            "OAuth2Permissions" = if ($spOAuth2PermissionsGrants){$spOAuth2PermissionsGrants}Else{"Not Configured"}
        }

    }

    $SelectedColumns = $AppReport | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | Out-GridView -PassThru -Title "Select your column"
    $AppReportData = $AppReport | Select-Object -Property $SelectedColumns | Sort-Object -Property Displayname
    $AppReportData | Out-GridView -Title "Application Registration Report - $Date" -PassThru


    If ($ExportFile){
        Switch ($ExportFile) {
            "CSV" {
                Write-host "Generating the CSV Report." -ForegroundColor Green
                $AppReportData | Export-Csv -Path ".\$Filename-App.csv" -NoTypeInformation
            }
            "HTML" {
                Write-host "Generating the HTML Report." -ForegroundColor Green
                $AppReportData | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h1><center>Application Registration Report - $Date</center></h1></font>" | Out-File "$Filename.html"
            }
            Default {
                Write-host "Generating the CSV Report." -ForegroundColor Green
                $AppReportData | Export-Csv -Path ".\$Filename-App.csv" -NoTypeInformation
                Write-host "Generating the HTML Report." -ForegroundColor Green
                $AppReportData | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h1><center>Application Registration Report - $Date</center></h1></font>" | Out-File "$Filename.html"
            }
        }
    }
}

Function GetServicePrincipal {
    $Filename = "ServicePrincipalReport - $($Date)"
    $SPReport = @()
    ## Get Service Principal
    ForEach ($ServicePrincipal in $(Get-MgServicePrincipal)){
        Write-Host $($ServicePrincipal.DisplayName) -ForegroundColor Yellow

        (Get-MgServicePrincipal -Filter "AppId eq '$($ServicePrincipal.AppId)'").Oauth2PermissionGrants

        $SPReport += New-Object PSobject -Property @{
            "Displayname"  = if ($ServicePrincipal.DisplayName){$ServicePrincipal.DisplayName}Else{"Not Configured"}
            "Enabled" = if ($ServicePrincipal.AccountEnabled){$ServicePrincipal.AccountEnabled}Else{"Not Configured"}
            "AppDisplayname"  = if ($ServicePrincipal.AppDisplayName){$ServicePrincipal.AppDisplayName}Else{"Not Configured"}
            "SPType" = if ($ServicePrincipal.ServicePrincipalType){$ServicePrincipal.ServicePrincipalType}Else{"Not Configured"}
            "SPNames" = if ($ServicePrincipal.ServicePrincipalNames){$ServicePrincipal.ServicePrincipalNames}Else{"Not Configured"}
            "Description"  = if ($ServicePrincipal.Description){$ServicePrincipal.Description}Else{"Not Configured"}
            "Owners" = if ($ServicePrincipal.Owners){$ServicePrincipal.Owners}Else{"Not Configured"}
            "ID"  = if ($ServicePrincipal.Id){$ServicePrincipal.Id}Else{"Not Configured"}
            "Endpoints"  = if ($ServicePrincipal.Endpoints){$ServicePrincipal.Endpoints}Else{"Not Configured"}
            "MemberOf"  = if ($ServicePrincipal.MemberOf){$ServicePrincipal.MemberOf}Else{"Not Configured"}
            "PreferredSingleSignOnMode"  = if ($ServicePrincipal.PreferredSingleSignOnMode){$ServicePrincipal.PreferredSingleSignOnMode}Else{"Not Configured"}
            "SamlSingleSignOnSettings"  = if ($ServicePrincipal.SamlSingleSignOnSettings.RelayState){$ServicePrincipal.SamlSingleSignOnSettings.RelayState}Else{"Not Configured"}
            "PreferredTokenSigninKeyThumbprint"  = if ($ServicePrincipal.PreferredTokenSigninKeyThumbprint){$ServicePrincipal.PreferredTokenSigninKeyThumbprint}Else{"Not Configured"}
            "SignInAudience" = if ($ServicePrincipal.SignInAudience){$ServicePrincipal.SignInAudience}Else{"Not Configured"}
            "NotifEmailAddresses" = if ($ServicePrincipal.NotifEmailAddresses){$ServicePrincipal.NotifEmailAddresses}Else{"Not Configured"}
            "ServicePrincipalTemplateId" = if ($ServicePrincipal.ServicePrincipalTemplateId){$ServicePrincipal.ApplicationTemplateId}Else{"Not Configured"}
            "AppId"  = if ($ServicePrincipal.AppId){$ServicePrincipal.AppId}Else{"Not Configured"}
            "AppRoleAssignmentRequired" = if ($ServicePrincipal.AppRoleAssignmentRequired){$ServicePrincipal.AppRoleAssignmentRequired -join ","}Else{"Not Configured"}
            "AppRoles" = if ($ServicePrincipal.AppRoles.DisplayName){$ServicePrincipal.AppRoles.DisplayName -join ","}Else{"Not Configured"}
            "AppRoleAssignments" = if ($ServicePrincipal.AppRoleAssignments){$ServicePrincipal.AppRoleAssignments -join ","}Else{"Not Configured"}
            "AppRoleAssignedTo" = if ($ServicePrincipal.AppRoleAssignedTo){$ServicePrincipal.AppRoleAssignedTo -join ","}Else{"Not Configured"}
            "AppOwnerOrganizationId" = if ($ServicePrincipal.AAppOwnerOrganizationId){$ServicePrincipal.AppOwnerOrganizationId -join ","}Else{"Not Configured"}
            "Homepage"  = if ($ServicePrincipal.Homepage){$ServicePrincipal.Homepage -join ","}Else{"Not Configured"}
            "LogintUrl" = if ($ServicePrincipal.LogintUrl){$ServicePrincipal.LogintUrl -join ","}Else{"Not Configured"}
            "LogoutUrl" = if ($ServicePrincipal.LogoutUrl){$ServicePrincipal.LogoutUrl -join ","}Else{"Not Configured"}
            "ReplyUrls" = if ($ServicePrincipal.ReplyUrls){$ServicePrincipal.ReplyUrls -join ","}Else{"Not Configured"}
            "HomeRealmDiscoveryPolicies" = if ($ServicePrincipal.HomeRealmDiscoveryPolicies){$ServicePrincipal.HomeRealmDiscoveryPolicies}Else{"Not Configured"}
            "ClaimsMappingPolicies" = if ($ServicePrincipal.ClaimsMappingPolicies){$ServicePrincipal.ClaimsMappingPolicies}Else{"Not Configured"}
            "InfoLogoUrl" = if ($ServicePrincipal.Info.LogoUrl){$ServicePrincipal.Info.LogoUrl}Else{"Not Configured"}
            "InfoMarketingUrl" = if ($ServicePrincipal.Info.MarketingUrl){$ServicePrincipal.Info.MarketingUrl -join ","}Else{"Not Configured"}
            "InfoPrivacyStatementUrl" = if ($ServicePrincipal.Info.PrivacyStatementUrl){$ServicePrincipal.Info.PrivacyStatementUrl -join ","}Else{"Not Configured"}
            "InfoSupportUrl" = if ($ServicePrincipal.Info.SupportUrl){$ServicePrincipal.Info.SupportUrl -join ","}Else{"Not Configured"}
            "InfoTermsOfServiceUrl" = if ($ServicePrincipal.Info.TermsOfServiceUrl){$ServicePrincipal.Info.TermsOfServiceUrl -join ","}Else{"Not Configured"}
            "Notes" = if ($ServicePrincipal.Notes){$ServicePrincipal.Notes}Else{"Not Configured"}
            "Oauth2PermissionGrants" = if ($ServicePrincipal.Oauth2PermissionGrants){$ServicePrincipal.Oauth2PermissionGrants}Else{"Not Configured"}
            "Oauth2PermissionScopes" = if ($ServicePrincipal.Oauth2PermissionScopes.Value){$ServicePrincipal.Oauth2PermissionScopes.Value}Else{"Not Configured"}
            "Oauth2PermissionScopesType" = if ($ServicePrincipal.Oauth2PermissionScopes.Type){$ServicePrincipal.Oauth2PermissionScopes.Type}Else{"Not Configured"}
            "Oauth2PermissionScopesAdminConsent" = if ($ServicePrincipal.Oauth2PermissionScopes.AdminConsentDescription){$ServicePrincipal.Oauth2PermissionScopes.AdminConsentDescription}Else{"Not Configured"}
            "Oauth2PermissionScopesUserConsent" = if ($ServicePrincipal.Oauth2PermissionScopes.UserConsentDescription){$ServicePrincipal.Oauth2PermissionScopes.UserConsentDescription}Else{"Not Configured"}
            "PassCred" = if ($ServicePrincipal.PasswordCredentials){$ServicePrincipal.PasswordCredentials -join ","}Else{"Not Configured"}
            "KeyCred" = if ($ServicePrincipal.KeyCredentials){$ServicePrincipal.KeyCredentials -join ","}Else{"Not Configured"}
            "TokenEncryptionKeyId" = if ($ServicePrincipal.TokenEncryptionKeyId){$ServicePrincipal.TokenEncryptionKeyId}Else{"Not Configured"}
            "TokenIssuancePolicies" = if ($ServicePrincipal.TokenIssuancePolicies){$ServicePrincipal.TokenIssuancePolicies}Else{"Not Configured"}
            "TokenLifetimePolicies" = if ($ServicePrincipal.TokenLifetimePolicies){$ServicePrincipal.TokenLifetimePolicies}Else{"Not Configured"}
            "Tags" = if ($ServicePrincipal.Tags){$ServicePrincipal.Tags -join ","}Else{"Not Configured"}
            "AddIns" = if ($ServicePrincipal.AddIns){$ServicePrincipal.AddIns -join ","}Else{"Not Configured"}
            "DeletedDateTime" = if ($ServicePrincipal.DeletedDateTime){$ServicePrincipal.DeletedDateTime}Else{"Not Configured"}
            "DisabledByMicrosoftStatus" = if ($ServicePrincipal.DisabledByMicrosoftStatus){$ServicePrincipal.DisabledByMicrosoftStatus}Else{"Not Configured"}

        }

    }

    $SelectedColumns = $SPReport | Get-Member -MemberType NoteProperty | Select -ExpandProperty Name | Out-GridView -PassThru -Title "Select your column"
    $SPReportData = $SPReport | Select-Object -Property $SelectedColumns | Sort-Object -Property Displayname
    $SPReportData | Out-GridView -Title "Service Principal Report - $Date" -PassThru


    If ($ExportFile){
        Switch ($ExportFile) {
            "CSV" {
                Write-host "Generating the CSV Report." -ForegroundColor Green
                $SPReportData | Export-Csv -Path ".\$Filename-SP.csv" -NoTypeInformation
            }
            "HTML" {
                Write-host "Generating the HTML Report." -ForegroundColor Green
                $SPReportData | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h1><center>Service Principal Report - $Date</center></h1></font>" | Out-File "$Filename.html"
            }
            Default {
                Write-host "Generating the CSV Report." -ForegroundColor Green
                $SPReportData | Export-Csv -Path ".\$Filename-SP.csv" -NoTypeInformation
                Write-host "Generating the HTML Report." -ForegroundColor Green
                $SPReportData | ConvertTo-HTML -head $Head -Body "<font color=`"Black`"><h1><center>Service Principal Report - $Date</center></h1></font>" | Out-File "$Filename.html"
            }
        }
    }

}

Function GetPermissions {
    param($AppId)
    # Get all delegated permissions for the service principal
    $spOAuth2PermissionsGrants = Get-AzureADOAuth2PermissionGrant -All $true | Where-Object { $_.ClientId -eq $AppId }
    return $spOAuth2PermissionsGrants
}

## Connect to Azure AD
#requires -Modules Microsoft.Graph.Applications, Microsoft.Graph.Authentication, Microsoft.Graph.Identity.SignIns
Try {
    ## MgGraph
    # Connect-MgGraph -Scopes Application.Read.All, Application.ReadWrite.All, DelegatedPermissionGrant.ReadWrite.All
    Connect-MgGraph -Scopes Application.Read.All
    Write-Host "Module MgGraph imported" -ForegroundColor Green
}
Catch {
    Write-Host "Import module failed" -ForegroundColor Red
}

$Global:Date = Get-Date -format dd-MMMM-yyyy
$Global:Head = @"  
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

$Parameter = $MyInvocation.BoundParameters.Keys
Switch ($Parameter) {
    "Applications" {
        GetApplications
    }
    "ServicePrincipal" {
        GetServicePrincipal
    }
}

Disconnect-MgGraph
