$CSV = Import-Csv .\ITRO.csv -Header 'User','Server','Path'


foreach ($item in $CSV)
{

set-ADUser $item.user -Server baincapital.com -HomeDirectory $null -HomeDrive $null

}



foreach ($item in $csv)
{

$Accounts = Get-NTFSAccess $item.Path | Where-Object {$_.Account -notlike "*Domain*" -and $_.Account -notlike "*SG_*" -and $_.Account -notlike "*svc*" -and $_.Account -notlike "*fs_*" -and $_.Account -notlike "*BUILTIN*" -and $_.Account -notlike "*NT AUTH*"}


foreach ($Account in $Accounts)
{

get-item $account.Fullname | Remove-NTFSAccess -account $account.account -AccessRights CreateFiles,CreateDirectories,WriteAttributes,WriteExtendedAttributes,Delete
get-childitem -recurse $account.Fullname | Remove-NTFSAccess -account $account.account -AccessRights CreateFiles,CreateDirectories,WriteAttributes,WriteExtendedAttributes,Delete

}



}
