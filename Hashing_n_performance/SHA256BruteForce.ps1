Start-Transcript -Path "$psscriptroot\Task1$(get-date -f yyyy-MM-dd-mm-ss).log"
function hashSmallerFile(){
$ElapsedTime = 0
    $StartTime = $(get-date)
    $ElapsedTime = $(get-date) - $StartTime
    $sml=0
    while($ElapsedTime -lt 1){
        Get-FileHash -Path $PSScriptRoot\256bitFile032.dat -Algorithm $algorithm | Out-Null #optimizing
        $ElapsedTime = ($(get-date) - $StartTime).TotalSeconds
        $sml=$sml +1
    }
    return $sml
 }
function hashLargerFile(){
        $ElapsedTime = 0
    $StartTime = $(get-date)
    $ElapsedTime = $(get-date) - $StartTime
    $lar=0
    while($ElapsedTime -lt 1){
        Get-FileHash -Path $PSScriptRoot\1KbyeFile1.dat -Algorithm $algorithm | Out-Null #optimizing
        $ElapsedTime = ($(get-date) - $StartTime).TotalSeconds
        $lar=$lar +1
    }
    return $lar
}

function Hash-TwoFiles($algorithm){
    $f = new-object System.IO.FileStream $PSScriptRoot\256bitFile032.dat, Create, ReadWrite
    $f.SetLength(31)
    $f.Close()
    $f = new-object System.IO.FileStream $PSScriptRoot\1KbyeFile1.dat, Create, ReadWrite
    $f.SetLength(1000)
    $f.Close()
    $secSml=0
    $secLar=0
    while($secSml -le 0 -or $secLar -le 0){#randomly generates a zero so I put this here
        $secSml=0
        $secLar=0
        $secSml=hashSmallerFile
        $secLar=hashLargerFile
    }

    Write-Host $algorithm
    Write-Host Small file hashed `t$secSml times Largeer file hashed `t$secLar times
    Return @($secSml,$secLar)
}
$StartupVars = @()
$StartupVars = Get-Variable | Select-Object -ExpandProperty Name

$hashMap=@{"MACTripleDES"=Hash-TwoFiles -algorithm MACTripleDES;
"MD5"=Hash-TwoFiles -algorithm MD5;
"SHA1"=Hash-TwoFiles -algorithm SHA1;
"SHA256"=Hash-TwoFiles -algorithm SHA256;
"SHA384"=Hash-TwoFiles -algorithm SHA384;
"SHA512"=Hash-TwoFiles -algorithm SHA384}
Write-Host ------------------------------
Write-Host Comparison Metrics Small File
Write-Host ------------------------------
$hashAlg=@($hashMap.MACTripleDES[0],$hashMap.MD5[0],$hashMap.SHA1[0],$hashMap.SHA256[0],$hashMap.SHA384[0],$hashMap.SHA512[1])
$metrics=$hashAlg | measure -minimum -maximum

foreach($key in $hashMap.Keys){
    if($hashMap.$key[0] -eq $metrics.Minimum){
    Write-host Worst Performing Algorithm    
    Write-host $key : $metrics.Minimum`n
    }
    if($hashMap.$key[0] -eq $metrics.Maximum){
    Write-host Best Performing Algorithm    
    Write-host $key : $metrics.Maximum`n
    }
}
Write-Host ------------------------------
Write-Host Comparison Metrics Larger File
Write-Host ------------------------------

$hashAlg=@($hashMap.MACTripleDES[1],$hashMap.MD5[1],$hashMap.SHA1[1],$hashMap.SHA256[1],$hashMap.SHA384[1],$hashMap.SHA512[1])
$metrics=$hashAlg | measure -minimum -maximum

foreach($key in $hashMap.Keys){
    if($hashMap.$key[1] -eq $metrics.Minimum){
    Write-host Worst Performing Algorithm    
    Write-host $key : $metrics.Minimum`n
    }
    if($hashMap.$key[1] -eq $metrics.Maximum){
    Write-host Best Performing Algorithm    
    Write-host $key : $metrics.Maximum`n
    }
}

$possibilities=115792089237316195423570985008687907853269984665640564039457584007913129639936#72,057,594,037,927,936
foreach($key in $hashMap.Keys){
    Write-Host Algorithm: $key
    $smallfileHashPerSeconds=$hashMap.$key[0]
    $largefileHashPerSeconds=$hashMap.$key[1]
    $secondTookForSmallFile=$possibilities/$smallfileHashPerSeconds
    $secondTookForLargeFile=$possibilities/$largefileHashPerSeconds
    $daysSmall=$secondTookForSmallFile/86400
    $daysLarge=$secondTookForLargeFile/86400
    $yearSmall=[Math]::Truncate($daysSmall/365)
    $yearLarge=[Math]::Truncate($daysLarge/365)
    $rdaysSmall=[Math]::Truncate($daysSmall%365)
    $rdaysLarge=[Math]::Truncate($daysLarge%365)
    Write-Host Collision time for Small $yearSmall years and $rdaysSmall days
    Write-Host Collision time for Large $yearLarge years and $rdaysLarge days
}
Write-Host Hardware Specs
#https://community.spiceworks.com/scripts/show/1831-get-computer-system-and-hardware-information
$computerSystem = Get-CimInstance CIM_ComputerSystem
$computerBIOS = Get-CimInstance CIM_BIOSElement
$computerOS = Get-CimInstance CIM_OperatingSystem
$computerCPU = Get-CimInstance CIM_Processor
$computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"
$cpu="CPU: " + $computerCPU.Name
$hd="HDD Capacity: "  + "{0:N2}" -f ($computerHDD.Size/1GB) + "GB"
$avS="HDD Space: " + "{0:P2}" -f ($computerHDD.FreeSpace/$computerHDD.Size) + " Free (" + "{0:N2}" -f ($computerHDD.FreeSpace/1GB) + "GB)"
$ram="RAM: " + "{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB) + "GB"
$OS="Operating System: " + $computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion
$reb="Last Reboot: " + $computerOS.LastBootUpTime
Write-Host $cpu `n $hd `n $avS `n $ram `n $OS `n $reb
Stop-Transcript