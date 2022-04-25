
[CmdletBinding()]
param (
    [Parameter(Mandatory=$true, Position=0)]
    $AppName,
    [Parameter(Mandatory=$true, Position=1)]
    [ValidateSet("Yes", "No")]
    $SelfSigned,
    [Parameter(Mandatory=$false, Position=3)]
    $Certificate,
    [Parameter(Mandatory=$true, Position=4)]
    $TenantId,
    [Parameter(Mandatory=$true, Position=5)]
    $AccountUPN
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
    If ($Error) {
        Write-Host "Export certificate failed" -ForegroundColor Red
    }
    $CertPath = "$((Get-Location).Path)\$ApplicationName.cer"
    LoadCertificate -Path $CertPath
}

Function LoadCertificate {
    param (
        [Parameter(Mandatory=$true, Position=0)]
        $Path
    )
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
    If (Get-AzureADApplication -Filter "DisplayName eq '$ApplicationName'") {
        $Count = (Get-AzureADApplication -Filter "DisplayName eq '$ApplicationName'").Count
        If ($Number -gt 1){
            Write-Host "!!! You have more than 1 application" -ForegroundColor Red
            Exit
        }
        [Boolean]$AlreadyExist = $true
    }
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
    New-AzureADApplicationKeyCredential -ObjectId $ObjectId -CustomKeyIdentifier $base64Thumbprint -Type AsymmetricX509Cert -Usage Verify -Value $keyValue -EndDate $Certificate.GetExpirationDateString()
}

$Error.Clear()
## Variables
[Boolean]$AlreadyExist = $false

## Connect to Azure AD
#requires -Modules AzureAD
Try {
    Connect-AzureAD -AccountId $AccountUPN -TenantId $TenantId
    Write-Host "Module AzureAD imported" -ForegroundColor Green
}
Catch {
    Write-Host "Import module failed" -ForegroundColor Red
}

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
    If ($Error) {
        Write-Host "Key not added" -ForegroundColor Red
    }
} Elseif ($IfAppExist -eq $false){
    CreateApp -ApplicationName $AppName
    If (!($Error)) {
        Write-Host "Application created" -ForegroundColor Green
    }
    ## Get Application ID
    $AppId = GetAppId -ApplicationName $AppName
    ## Add key
    AddKey -ObjectId $AppId -base64Thumbprint $base64Thumbprint -keyValue $keyValue -Certificate $Cert
} Else {
    Write-Host " Something went wrong" -ForegroundColor Red
}

If (!($Error)) {
    Write-Host "** Well done !! **" -ForegroundColor Green
} Else {
    Write-Host " Something went wrong" -ForegroundColor Red
}
