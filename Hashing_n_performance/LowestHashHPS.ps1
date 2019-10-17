Start-Transcript -Path "$psscriptroot\Task3$(get-date -f yyyy-MM-dd-mm-ss).log"
function hs{
    $stuffString=Generate-RandomString -Length 30
    $stuffString > $PSScriptRoot\task3InputString.dat
    $newHash=Get-FileHash -Path $PSScriptRoot\task3InputString.dat -Algorithm SHA256
    if($Global:hash.Hash -eq $null){
        $Global:hash=$newHash
        $Global:hash.Hash
        return
    }
    [int[]][char[]]$AsciiNumberValues=$Global:hash.Hash
    [int[]][char[]]$AsciiNumberValues2=$newHash.Hash

    $AsciiTotal=0
    foreach($val in $AsciiNumberValues){
       $AsciiTotal=$val + $AsciiTotal
    }
    $AsciiTotal2=0
    foreach($val in $AsciiNumberValues2){
       $AsciiTotal2=$val + $AsciiTotal2
    }

    if($AsciiTotal -gt $AsciiTotal2){
        $Global:hash=$newHash
        $Global:hash.Hash
    }
}

function Generate-RandomString{
    param (
        [int]$Length
    )
    $set    = "abcdefghijklmnopqrstuvwxyz0123456789".ToCharArray()
    $result = ""
    for ($x = 0; $x -lt $Length; $x++) {
        $result += $set | Get-Random
    }
    return $result
}
function Find-LowestHashIn10Secs(){
    $Global:hash.Hash=$null
    $ElapsedTime = 0
    $StartTime = $(get-date)
    $ElapsedTime = $(get-date) - $StartTime
    while($ElapsedTime -lt 10){
        hs
        $ElapsedTime = ($(get-date) - $StartTime).TotalSeconds
    }
    Write-Host Lowest hash produced in 10 seconds $Global:hash.Hash
    }

function Find-LowestHashIn20Secs(){
    $Global:hash.Hash=$null
    $ElapsedTime = 0
    $StartTime = $(get-date)
    $ElapsedTime = $(get-date) - $StartTime
    while($ElapsedTime -lt 20){
        hs
        $ElapsedTime = ($(get-date) - $StartTime).TotalSeconds
    }
    Write-Host Lowest hash produced in 20 seconds $Global:hash.Hash
    }
function Find-LowestHashIn30Secs(){
    $Global:hash.Hash=$null
    $ElapsedTime = 0
    $StartTime = $(get-date)
    $ElapsedTime = $(get-date) - $StartTime
    while($ElapsedTime -lt 30){
        hs
        $ElapsedTime = ($(get-date) - $StartTime).TotalSeconds
    }
    Write-Host Lowest hash produced in 30 seconds $Global:hash.Hash
    }

function find-lowestInTenAttempts10Secs(){
    $TimedHashesGenerated = New-Object System.Collections.ArrayList
    $lowestHash=$null
    for($i = 0; $i -lt 10; $i = $i + 1){
        Find-LowestHashIn10Secs
        $TimedHashesGenerated.Add($Global:hash.hash)
    }

    $numberValues = New-Object System.Collections.ArrayList
    foreach($hast in $TimedHashesGenerated){
    [int[]][char[]]$TimedAsciiNumberValues=$hast

        $TimedAsciiTotal=0
        foreach($val in $TimedAsciiNumberValues){
           $TimedAsciiTotal=$val + $TimedAsciiTotal
        }
        $numberValues.Add($TimedAsciiTotal)
    }
    $averageAsciiValue=$numberValues | measure -Average
    return $averageAsciiValue
}
function find-lowestInTenAttempts20Secs(){
    $TimedHashesGenerated = New-Object System.Collections.ArrayList
    $lowestHash=$null
    for($i = 0; $i -lt 10; $i = $i + 1){
        Find-LowestHashIn20Secs
        $TimedHashesGenerated.Add($Global:hash.hash)
    }

    $numberValues = New-Object System.Collections.ArrayList
    foreach($hast in $TimedHashesGenerated){
    [int[]][char[]]$TimedAsciiNumberValues=$hast

        $TimedAsciiTotal=0
        foreach($val in $TimedAsciiNumberValues){
           $TimedAsciiTotal=$val + $TimedAsciiTotal
        }
        $numberValues.Add($TimedAsciiTotal)
    }
    $averageAsciiValue=$numberValues | measure -Average
    return $averageAsciiValue
}
function find-lowestInTenAttempts30Secs(){
    $TimedHashesGenerated = New-Object System.Collections.ArrayList
    $lowestHash=$null
    for($i = 0; $i -lt 10; $i = $i + 1){
        Find-LowestHashIn30Secs
        $TimedHashesGenerated.Add($Global:hash.hash)
    }

    $numberValues = New-Object System.Collections.ArrayList
    foreach($hast in $TimedHashesGenerated){
    [int[]][char[]]$TimedAsciiNumberValues=$hast

        $TimedAsciiTotal=0
        foreach($val in $TimedAsciiNumberValues){
           $TimedAsciiTotal=$val + $TimedAsciiTotal
        }
        $numberValues.Add($TimedAsciiTotal)
    }
    $averageAsciiValue=$numberValues | measure -Average
    return $averageAsciiValue
}
$avg1=find-lowestInTenAttempts10Secs
$avg2=find-lowestInTenAttempts20Secs
$avg3=find-lowestInTenAttempts30Secs

Write-Host Average based on 10 seconds was: $avg1.Average
Write-Host Average based on 20 seconds was: $avg2.Average
Write-Host Average based on 30 seconds was: $avg3.Average
$metrics=@($avg1.Average,$avg2.Average,$avg3.Average) | measure -Average -Maximum -Minimum -Sum
$midpoint=(($metrics.Maximum - $metrics.Minimum)/2)+$metrics.Minimum
$MaxmimumIncreaseDecrease=$metrics.Maximum-$midpoint
$changepersecond=$MaxmimumIncreaseDecrease/60
$formula=$metrics.Minimum+$changepersecond
Write-Host Lowest value given second for the fomula is $formula and a increase of $changepersecond ascii values per/second
Write-Host My thought proces is the minimun and best possible outcome is the minimum over the entire period and could hypothetically happen in the first second, however when considering the average change over time the ascii total number increases at given rate during pass of each second relative to the midpoint it goes up or down.
Stop-Transcript