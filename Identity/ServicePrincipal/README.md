# Service Principal
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PS-5.1-blue.svg)]()
## Project Goals
- Create an application with a certificate.

## Current Version
- Version: 1.0

## History
- April 24, 2022 : Contribution

## Using the script
PS> Create-ServicePrincipal.ps1 -AppName "SP-AzureAD" -SelfSigned "Yes"

## Using the script
PS> Create-ServicePrincipal.ps1 -AppName "SP-AzureAD" -SelfSigned "No" -Certificate "C:\<mycertificate>.cer"

## Screenshot
### First execution with Self-Signed
![image](https://user-images.githubusercontent.com/94542446/165003230-0907dbcd-35df-4c66-8931-8b56c8b74d28.png)
<img width="302" alt="image" src="https://user-images.githubusercontent.com/94542446/165003261-0a76006b-5da9-4fd0-bcb5-a95992f301bf.png">

Portal Azure

<img width="449" alt="image" src="https://user-images.githubusercontent.com/94542446/165003335-a9d80102-3c4e-49fb-8631-92c9e92b787a.png">

Certificates: The thumbprint is not available.

<img width="485" alt="image" src="https://user-images.githubusercontent.com/94542446/165003370-4369c879-3ae1-4590-a675-f78799e54bcb.png">

Certificates: if you import manually the same certificate

<img width="477" alt="image" src="https://user-images.githubusercontent.com/94542446/165003520-543da798-0fc0-4ada-b166-0144038ef7ad.png">


### First execution with specific certificate


### Add key

## And then ??
### Connect to AzureAD via AzureAD module
Connect-AzureAD -AppId <ObjectId> -Certificatethumbprint <thumbprint> -TenantId <TenantId>

### Connect to AzureAD via MgGraph module
Connect-MgGraph -ClientID <AppId> -TenantId <TenantId> -CertificateThumbprint <thumbprint>

![image](https://user-images.githubusercontent.com/94542446/165004332-dbada788-c2ac-47b9-b124-a88965b297e0.png)


# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).
