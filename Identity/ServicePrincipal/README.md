# Service Principal
[![Minimum Supported PowerShell Version](https://img.shields.io/badge/PS-5.1-blue.svg)]()

## Current Version
- Version: 1.0

## History
- April 24, 2022 : Contribution

## Using the script
```
PS> Create-ServicePrincipal.ps1 -AppName "SP-AzureAD" -SelfSigned "Yes" -Tenantid "<tenantid>" -AccountUPN "<UPN>"
```
## Using the script
```
PS> Create-ServicePrincipal.ps1 -AppName "SP-AzureAD" -SelfSigned "No" -Certificate "C:\<mycertificate>.cer"
```
## Screenshot
### First execution with Self-Signed
![image](https://user-images.githubusercontent.com/94542446/165003230-0907dbcd-35df-4c66-8931-8b56c8b74d28.png)
![image](https://user-images.githubusercontent.com/94542446/165003261-0a76006b-5da9-4fd0-bcb5-a95992f301bf.png)

Portal Azure

![image](https://user-images.githubusercontent.com/94542446/165003335-a9d80102-3c4e-49fb-8631-92c9e92b787a.png)

Certificates: The thumbprint is not available.

![image](https://user-images.githubusercontent.com/94542446/165003370-4369c879-3ae1-4590-a675-f78799e54bcb.png)

Certificates: if you import manually the same certificate

![image](https://user-images.githubusercontent.com/94542446/165003520-543da798-0fc0-4ada-b166-0144038ef7ad.png)


### First execution with specific certificate


### Add specific key
![image](https://user-images.githubusercontent.com/94542446/165004786-a0cba9b5-ca3a-4073-b4d4-f7dd0b0a0b21.png)


## And then ??
### Connect to AzureAD via AzureAD module
```
Connect-AzureAD -AppId <ObjectId> -Certificatethumbprint <thumbprint> -TenantId <TenantId>
```
### Connect to AzureAD via MgGraph module
```
Connect-MgGraph -ClientID <AppId> -TenantId <TenantId> -CertificateThumbprint <thumbprint>
```
![image](https://user-images.githubusercontent.com/94542446/165004332-dbada788-c2ac-47b9-b124-a88965b297e0.png)
![image](https://user-images.githubusercontent.com/94542446/165107555-c5c02d7c-f3d4-4fd6-b915-9609304c0119.png)


# Disclaimer
See [DISCLAIMER](./DISCLAIMER.md).
