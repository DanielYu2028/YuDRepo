#If not logged in already
#Connect-AzAccount

Select-AzureSubscription -Default "TfNSW OS ODL NonProd"

#Create the SQL Server. Required variables include resource group, location, server name, server version, admin credentials. 
#Optional variables include -Tags, -PublicNetworkAccess, -MinimalTlsVersion, -DefaultProfile, -Confirm
#Reference: https://docs.microsoft.com/en-us/powershell/module/az.sql/new-azsqlserver?view=azps-4.4.0
New-AzSqlServer -ResourceGroupName "TOS-ENP-LAB-RGP-001" -Location "australiaeast" -ServerName "server01111111" -ServerVersion "12.0" -SqlAdministratorCredentials (Get-Credential) -Confirm

#Create a new Firewall rule to allow access to your SQL server 
#Reference: https://docs.microsoft.com/en-us/powershell/module/az.sql/new-azsqlserverfirewallrule?view=azps-4.4.0 
New-AzSqlServerFirewallRule -ResourceGroupName "TOS-ENP-LAB-RGP-001" -ServerName "server01111111" -FirewallRuleName "YuDHomeAccess2" -StartIpAddress "191.239.64.14" -EndIpAddress "191.239.64.14"

#import .bacpac database file to existing server 
#New-AzSqlDatabaseImport -ResourceGroupName "TOS-ENP-LAB-RGP-001" -ServerName "server01111111" -DatabaseName "DBname" -DatabaseMaxSizeBytes "262144000" -StorageKeyType "StorageAccessKey" -StorageKey $(Get-AzStorageAccountKey -ResourceGroupName "TOS-ENP-LAB-RGP-001" -StorageAccountName "databasewebtirf").Value[0] -StorageUri "https://databasewebtirf.blob.core.windows.net/sampledatabase/WebTIRF202003.bacpac" -Edition "Standard" -ServiceObjectiveName "S3" -AdministratorLogin "dbadmin" -AdministratorLoginPassword "Password01"

#Pass your password into a Secure String. 
#Import the database with all the required variables (Resource Group, server name, database name, storage key type, storage key, storage URI, Admin login, Admin password (created in a secure string), Edition, Service Objective Name and database max size. 
#Reference: https://docs.microsoft.com/en-us/powershell/module/az.sql/new-azsqldatabaseimport?view=azps-4.4.0 
$myDbUsername = Read-Host -Prompt "Enter your username/email" 
$myDbPassword = Read-Host -Prompt "Enter your password" -AsSecureString
New-AzSqlDatabaseImport -ResourceGroupName "TOS-ENP-LAB-RGP-001" -ServerName "server01111111" -DatabaseName "Database02" -StorageKeyType "StorageAccessKey" -StorageKey $(Get-AzStorageAccountKey -ResourceGroupName "TOS-ENP-LAB-RGP-001" -StorageAccountName "databasewebtirf").Value[0] -StorageUri "https://databasewebtirf.blob.core.windows.net/sampledatabase/WebTIRF202003.bacpac" -AdministratorLogin "dbadmin1" -AdministratorLoginPassword $myDbPassword -Edition Standard -ServiceObjectiveName S0 -DatabaseMaxSizeBytes 5000000

#Export a database 
#Reference: https://docs.microsoft.com/en-us/powershell/module/az.sql/new-azsqldatabaseexport?view=azps-4.4.0 
$myDbPassword = Read-Host -Prompt "Enter your password" -AsSecureString
New-AzSqlDatabaseExport -ResourceGroupName "TOS-ENP-LAB-RGP-001" -ServerName "server01111111" -DatabaseName "Database02" -StorageKeyType "StorageAccessKey" -StorageKey $(Get-AzStorageAccountKey -ResourceGroupName "TOS-ENP-LAB-RGP-001" -StorageAccountName "databasewebtirf").Value[0] -StorageUri "https://databasewebtirf.blob.core.windows.net/sampledatabase/backedupversion.bacpac" -AdministratorLogin "dbadmin1" -AdministratorLoginPassword $myDbPassword

#New-AzSqlDatabaseImport -ResourceGroupName "RG01" -ServerName "Server01" -DatabaseName "Database01" -StorageKeyType "StorageAccessKey" -StorageKey "StorageKey01" -StorageUri "http://account01.blob.core.contoso.net/bacpacs/database01.bacpac" -AdministratorLogin "User" -AdministratorLoginPassword $SecureString -Edition Standard -ServiceObjectiveName S0 -DatabaseMaxSizeBytes 5000000

