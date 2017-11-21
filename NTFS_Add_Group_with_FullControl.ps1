#Adds Group recusivley to folder with Full Control
#Variable declaration
$Path = '\\domain.com\subfolder\subfolder'
$AdminGroup = 'domain.com\FileServer_Admins'
$AccessRights = 'FullControl'
$ScriptName = & { $myInvocation.ScriptName }
$LogFile = $ScriptName + '.txt'
$CsvFile = $ScriptName + '.csv'

$Date = Get-Date
Write-output ('Script starting on ' + $Date) | Out-File $LogFile -Append

#Import-Module
Import-Module 'NTFSSecurity'

$Date = Get-Date
Write-output ('Completed Import-Module on ' + $Date) | Out-File $LogFile -Append

#Enable-Privileges
Enable-Privileges

$Date = Get-Date
Write-output ('Completed Enable-Privileges on ' + $Date) | Out-File $LogFile -Append

#Get FolderList
$FolderList = Get-ChildItem2 -Recurse -Directory -Path $Path | Select-Object FullName

$Date = Get-Date
Write-output ('Completed FolderList on ' + $Date) | Out-File $LogFile -Append

#Take Ownership and control of Main Folder

Set-NTFSOwner -Path $Path -Account $AdminGroup
Add-NTFSAccess -Path $Path -Account $AdminGroup -AccessRights $AccessRights -AppliesTo ThisFolderOnly

$Date = Get-Date
Write-output ('Completed Take Ownership and control of Main Folder on ' + $Date) | Out-File $LogFile -Append

#Set Ownership and FullControl in subfolders

Write-Output 'Completed Set Ownership and Fullcontrol of the following:' | Out-File $LogFile -Append

foreach ($item in $FolderList) {
	$Folder = $NULL
	$Folder = $item.FullName
	
	Set-NTFSOwner -Path $Folder -Account $AdminGroup
	Add-NTFSAccess -Path $Folder -Account $AdminGroup -AccessRights $AccessRights -AppliesTo ThisFolderOnly
	
	$Date = Get-Date
	Write-output ($Folder + ' on ' + $Date) | Out-File $LogFile -Append
	
}

#Disable-Privileges
Disable-Privileges

$Date = Get-Date
Write-output ('Completed Disable-Privileges on ' + $Date) | Out-File $LogFile -Append

#Export Error Log
$Error | Export-Csv $CsvFile

$Date = Get-Date
Write-output ('Completed Export Error Log on ' + $Date) | Out-File $LogFile -Append

$Date = Get-Date
Write-output ('Script completed on ' + $Date) | Out-File $LogFile -Append