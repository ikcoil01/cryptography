#reference https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/get-random?view=powershell-6
Get-Random # This command gets a random integer between 0 (zero) and Int32.MaxValue.
Get-Random -Maximum 100 #Example 2: Get a random integer between 0 and 99

# Commands with the default seed are pseudorandom
Get-Random -Maximum 100 -SetSeed 23

$propabilityOfOne = 6/([Math]::Pow((([Math]::pi)),2))
Calculate-GCD -x 5 -y 2

function Calculate-GCD($x,$y){
    		if($y -eq 0){
            return $y
            }
            &{$t=(5%2) | Out-File $psscriptroot\hackystuff.txt}
            [int]$y="$pscriptroot\hackystuff.txt"
            Remove-Item -Path "$pscriptroot\hackystuff.txt"
            return Calculate-GCD($x,$y)
}