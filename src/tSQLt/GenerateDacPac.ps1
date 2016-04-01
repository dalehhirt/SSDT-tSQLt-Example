# Database server and name needed
Param(
     [string]$DatabaseServer = 'ddsql3'
    ,[string]$DatabaseInstance = 'DEFAULT'
    ,[string]$DatabaseName = 'tSQLt'
)

# Find the latest sqlpackage.exe
$last_version = 0;
for($i = 100; $i -le 190; $i += 10)
{
  $sqlpackage_file_name = "C:\Program Files (x86)\Microsoft SQL Server\" + $i + "\DAC\bin\sqlpackage.exe";
  If (Test-Path $sqlpackage_file_name) {
    $last_version = $i;
  }
}

# Run sqlpackage to extract DACPAC
If ($last_version -gt 0) {
  $msg = "SqlPackage version: " + $last_version;
  Write-Output $msg;
  $sqlpackage_file_name = "C:\Program Files (x86)\Microsoft SQL Server\" + $last_version + "\DAC\bin\sqlpackage.exe";
}

# SQL Functionality
Import-Module sqlps

cd C:

# drop and recreate db
$server = Get-Item SQLSERVER:\SQL\$DatabaseServer\$DatabaseInstance
$dbValue = dir SQLSERVER:\SQL\$DatabaseServer\$DatabaseInstance\Databases | where {$_.Name -eq $DatabaseName}
if($dbValue -ne $null) {
    write-host "Deleting old database"
    $server.KillAllProcesses($DatabaseName)
    $dbValue.Drop()
}

write-host "Creating database"
$db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database($server, $DatabaseName)
$db.Create()

# set clr on db server
write-host "Setting CLR"
Invoke-Sqlcmd -InputFile (Join-Path $PSScriptRoot "SetClrEnabled.sql") -ServerInstance $server -Database $DatabaseName

# deploy tsqlt
write-host "Deploying tSQLt"
Invoke-Sqlcmd -InputFile (Join-Path $PSScriptRoot "tSQLt.class.sql") -ServerInstance $server -Database $DatabaseName

#create dacpac
write-host "Creating dacpac"
$targetDacPacFile = (Join-Path $PSScriptRoot "tSQLt.dacpac")
&$sqlpackage_file_name /action:Extract /OverwriteFiles:True /tf:$targetDacPacFile /SourceServerName:$DatabaseServer /SourceDatabaseName:$DatabaseName /p:ExtractReferencedServerScopedElements=False