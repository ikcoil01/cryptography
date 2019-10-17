#2 options for running this import module will use file dependencies but will not work natively
#other option is run the below command thats commented out and remove the 2nd import
#Install-Module -Name encryptdecrypt
Import-Module $PSScriptRoot\FileCryptography.psm1
Import-Module $PSScriptRoot\FileCryptographyRSA.psm1

$file1 = new-object System.IO.FileStream $PSScriptRoot\file1, Create, ReadWrite
$file1.SetLength(1MB)
$file1.Close()
$file2 = new-object System.IO.FileStream $PSScriptRoot\file2, Create, ReadWrite
$file2.SetLength(1MB)
$file2.Close()
$key = New-CryptographyKey -Algorithm AES 
$StartTime = $(get-date)
Protect-File "$PSScriptRoot\file1" -Algorithm AES -Key $key -RemoveSource 
$EndTime = $(get-date) - $StartTime
Write-Host "AES Completed in $EndTime seconds."

$StartTime = $(get-date)
Protect-File "$PSScriptRoot\file2" -Algorithm AES -Key $key -RemoveSource 
$EndTime = $(get-date) - $StartTime
Write-Host "AES Completed in $EndTime seconds."


$file1 = new-object System.IO.FileStream $PSScriptRoot\file1RSA.txt, Create, ReadWrite
$file1.SetLength(1MB)
$file1.Close()
$file2 = new-object System.IO.FileStream $PSScriptRoot\file2RSA.txt, Create, ReadWrite
$file2.SetLength(1MB)
$file2.Close()

$StartTime = $(get-date)
New-EncryptedFile -SourceType File -ContentToEncrypt "$PSScriptRoot\file1RSA.txt" -CNOfNewCert "cerRSA1.cer"
$EndTime=$EndTime.TotalSeconds
Write-Host "RSA Completed in $EndTime seconds."

$StartTime = $(get-date)
New-EncryptedFile -SourceType File -ContentToEncrypt "$PSScriptRoot\file2RSA.txt" -CNOfNewCert "cerRSA2.cer"
$EndTime=$EndTime.TotalSeconds
Write-Host "RSA Completed in $EndTime seconds."
Get-DecryptedContent -SourceType File -ContentToDecrypt "$PSScriptRoot\file2RSA.aeskey.rsaencrypted" -PathToPfxFile "$PSScriptRoot\file1"