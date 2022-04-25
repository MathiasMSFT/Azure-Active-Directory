
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0)]
    $AppName,
    [Parameter(Mandatory=$true, Position=1)]
    [ValidateSet("Yes", "No")]
    $SelfSigned,
    [Parameter(Mandatory=$false, Position=3)]
    $Certificate
)

Function CreateSelfSignedCertificate {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ApplicationName
    )
    $notAfter = (Get-Date).AddMonths(6) # Valid for 6 months
    $UPN = Whoami /UPN
    ## Create a self signed certificate
    $Thumbprint = (New-SelfSignedCertificate -DnsName "$ApplicationName" -Subject $UPN -CertStoreLocation "cert:\CurrentUser\My" -Provider "Microsoft Enhanced RSA and AES Cryptographic Provider" -NotAfter $notAfter).Thumbprint
    Export-Certificate -Cert Cert:\CurrentUser\My\$Thumbprint -Type Cert -FilePath ".\$ApplicationName.cer"
    $CertPath = "$((Get-Location).Path)\$ApplicationName.cer"
    $CertPath
    LoadCertificate -Path $CertPath
}

Function LoadCertificate {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $Path
    )
    Write-Host "function LoadCertificate: $Path" -ForegroundColor Yellow
    $Global:Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate("$Path")
    $Global:KeyValue = [System.Convert]::ToBase64String($Cert.GetRawCertData())
    $CertHash = $Cert.GetCertHash()
    $Global:Base64Thumbprint = [System.Convert]::ToBase64String($CertHash)
}

Function CreateApp {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ApplicationName
    )
    New-AzureADApplication -DisplayName "$ApplicationName"
}
Function GetApp {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ApplicationName
    )
    # Write-Host "Function GetApp: Get if application exists" -ForegroundColor Yellow
    If (Get-AzureADApplication -Filter "DisplayName eq '$ApplicationName'") {
        # Write-Host "Function GetApp: Application exists, count number of it" -ForegroundColor Yellow
        $Count = (Get-AzureADApplication -Filter "DisplayName eq '$ApplicationName'").Count
        If ($Number -gt 1){
            Write-Host "!!! You have more than 1 application" -ForegroundColor Red
            Exit
        }
        [Boolean]$AlreadyExist = $true
    }
    # Write-Host "Function GetApp: $AlreadyExist" -ForegroundColor Green
    Return $AlreadyExist
}

Function GetAppId {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ApplicationName
    )
    $AppObjectIdValue = (Get-AzureADApplication -Filter "DisplayName eq '$ApplicationName'").ObjectId
    Return $AppObjectIdValue
}

Function AddKey {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $ObjectId,
        [Parameter(Mandatory=$true, Position=1)]
        $base64Thumbprint,
        [Parameter(Mandatory=$true, Position=2)]
        $keyValue,
        [Parameter(Mandatory=$true, Position=3)]
        $Certificate
    )
    # Write-Host "Function AddKey: Add key in application" -ForegroundColor Yellow
    New-AzureADApplicationKeyCredential -ObjectId $ObjectId -CustomKeyIdentifier $base64Thumbprint -Type AsymmetricX509Cert -Usage Verify -Value $keyValue -EndDate $Certificate.GetExpirationDateString()
}

## Variables
[Boolean]$AlreadyExist = $false

## Connect to Azure AD
#requires -Modules AzureAD
Connect-AzureAD -AccountId $($SelectedProfile.Account) -TenantId "ee942b75-82c7-42bc-9585-ccc5628492d9"
cls
## If SelfSigned
If ($SelfSigned -eq "Yes") {
    CreateSelfSignedCertificate -ApplicationName $AppName
} Else {
    LoadCertificate -Path $Certificate
}

## Get if application already exists
$IfAppExist = GetApp -ApplicationName $AppName
If ($IfAppExist -eq $true){
    ## Get Application ID
    $AppId = GetAppId -ApplicationName $AppName
    ## Add key
    AddKey -ObjectId $AppId -base64Thumbprint $base64Thumbprint -keyValue $keyValue -Certificate $Cert
} Elseif ($IfAppExist -eq $false){
    CreateApp -ApplicationName $AppName
    ## Get Application ID
    $AppId = GetAppId -ApplicationName $AppName
    ## Add key
    AddKey -ObjectId $AppId -base64Thumbprint $base64Thumbprint -keyValue $keyValue -Certificate $Cert
} Else {
    Write-Host " something went wrong" -ForegroundColor Red
}







<#
## Create the Service Principal and connect it to the Application
$sp = New-AzureADServicePrincipal -AppId $application.AppId
#>

# Connect-AzureAD -AppId $sp -Certificatethumbprint $cert -TenantId