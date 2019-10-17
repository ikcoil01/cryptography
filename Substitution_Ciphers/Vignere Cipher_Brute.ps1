
$alphabet_map=@{
a = ("0");
b = ("1");
c = ("2");
d = ("3");
e = ("4");
f = ("5");
g = ("6");
h = ("7");
i = ("8");
j = ("9");
k = ("10");
l = ("11");
m = ("12");
n = ("13");
o = ("14");
p = ("15");
q = ("16");
r = ("17");
s = ("18");
t = ("19");
u = ("20");
v = ("21");
w = ("22");
x = ("23");
y = ("24");
z = ("25");
}
$alphabet_map_array=@(
"a",
"b",
"c",
"d",
"e",
"f",
"g",
"h",
"i",
"j",
"k",
"l",
"m",
"n",
"o",
"p",
"q",
"r",
"s",
"t",
"u",
"v",
"w",
"x",
"y",
"z"
);
$maplimit=$alphabet_map.Count

function Encrypt-String {
    param (
        $stringToEncrypt,$key
    )
        $outputString=""
        $keyLoc = 0
        for($i =0; $i -lt $stringToEncrypt.Length; $i = $i + 1){
            if($keyLoc -gt $key.Length-1)
            {
                $keyLoc = 0
            }
            $char = Get-CharInString -stringOfCharacters $stringToEncrypt -location $i
            if($char -eq $null){continue}
            $keyChar = Get-CharInString -stringOfCharacters $key -location $keyLoc
            $charNumberValue=Get-NumberValueOfCharacter -character $char
            if($charNumberValue -like "skip"){continue}
            $keyCharNumberValue=Get-NumberValueOfCharacter -character $keyChar
            if($keyCharNumberValue -like "skip"){continue}
            $newCharNumberValue=$charNumberValue+$keyCharNumberValue
            if($newCharNumberValue -gt 25){
                $newCharNumberValue=$newCharNumberValue - 26
            }
            $keyLoc = $keyLoc + 1 
            $newChar=Get-CharacterAtNumber -number $newCharNumberValue
            $outputString=$outputString+$newChar
        }
        return $outputString
}
function Decrypt-String {
    param (
        $stringToDecrypt,$key
    )
        $outputString=""
        $keyLoc = 0
        for($i =0; $i -lt $stringToDecrypt.Length; $i = $i + 1){
            if($keyLoc -gt $key.Length-1)
            {
                $keyLoc = 0
            }
            $char = Get-CharInString -stringOfCharacters $stringToDecrypt -location $i
            if($char -eq $null){continue}
            $keyChar = Get-CharInString -stringOfCharacters $key -location $keyLoc
            $charNumberValue=Get-NumberValueOfCharacter -character $char
            if($charNumberValue -like "skip"){continue}
            $keyCharNumberValue=Get-NumberValueOfCharacter -character $keyChar
            if($keyCharNumberValue -like "skip"){continue}
            $newCharNumberValue=$charNumberValue-$keyCharNumberValue
            if($newCharNumberValue -lt 0){
                $newCharNumberValue=$newCharNumberValue + 26
            }
            $keyLoc = $keyLoc + 1 
            $newChar=Get-CharacterAtNumber -number $newCharNumberValue
            $outputString=$outputString+$newChar
        }
        return $outputString
}
function Get-CharInString {
    param (
        $stringOfCharacters,$location
    )
    try{
        $character=$stringOfCharacters[$location]
    }
    catch{
        Write-Error "Character Not found"
        exit
    }
    return $character
}

function Get-NumberValueOfCharacter {
    param (
        $character
    )
    try{
    $number=$alphabet_map."$character"
    }catch{
        return "skip"
    }
    if($number.Length -eq 0){
        return "skip"
    }
    return [Int32]$number
}
function Get-CharacterAtNumber {
    param (
        $number
    )
    if($number -gt 25 -or $number -lt 0){
        Write-Error "Number Cannot be greater than 25 or less the 0"
        exit
    }
    $char=$alphabet_map_array[$number]
    return $char
}
function Check-Decrypt{
    param (
        $knownContentsOfCipher,$stringDecrypted
    )
    if($DecryptedText.Contains("$knownContentsOfCipher")){
        Write-Host $DecryptedText
        $knownContentsOfCipher
        Write-Host "Possible match found type `"c`" to contine or `"e`" to exit and then press enter"
        $input=Read-Host
        if($input='c'){
            Write-Host "The key was:"
            Return $true
        }elseif ($input='e'){
            Write-Host "The key was:"
            Return $true
        } else {
        Write-Host "$input was invalid please try again"
        Check-Decrypt
        }

    }
    return $false
}
    
function BruteForce {
    param (
        $knownContentsOfCipher,$maxKeySize,$cipherText
    )
    if($maxKeySize -ge 1){
        foreach($letter in $alphabet_map_array){
        $showKey=$null
        $DecryptedText=$null
        $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter" 
        Write-Host "$letter : $DecryptedText"
        $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText
        if($showKey){
            Write-Host $letter
            exit
                }
            if($maxKeySize -ge 2){
                foreach($letter2 in $alphabet_map_array){
                    $showKey=$null
                    $DecryptedText=$null
                    $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2"
                    Write-Host "$letter$letter2 : $DecryptedText"
                    $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText
                    if($showKey){
                        Write-Host $letter$letter2
                        exit
                            }
                    if($maxKeySize -ge 3){
                        foreach($letter3 in $alphabet_map_array){
                            $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3"
                             $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText
                            Write-Host "$letter$letter2$letter3 : $DecryptedText"
                            if($showKey){
                                Write-Host $letter$letter2$letter3
                                exit
                            }
                            if($maxKeySize -ge 4){
                                foreach($letter4 in $alphabet_map_array){
                                    $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4"
                                     $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText  
                                    Write-Host "$letter$letter2$letter3$letter4 : $DecryptedText"
                                     if($showKey){
                                        Write-Host $letter$letter2$letter3$letter4
                                        exit
                                        }
                                    if($maxKeySize -ge 5){
                                        foreach($letter5 in $alphabet_map_array){
                                            $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4$letter5"
                                            $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText
                                            Write-Host "$letter$letter2$letter3$letter4$letter5 : $DecryptedText"
                                            if($showKey){
                                                Write-Host $letter$letter2$letter3$letter4$letter5
                                                exit
                                                                                }    
                                            if($maxKeySize -ge 6){
                                                foreach($letter6 in $alphabet_map_array){
                                                    $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4$letter5$letter6"
                                                    $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText
                                                    Write-Host "$letter$letter2$letter3$letter4$letter5$letter6 : $DecryptedText"
                                                    if($showKey){
                                                        Write-Host $letter$letter2$letter3$letter4$letter5$letter6
                                                        exit
                                                                }
                                                    if($maxKeySize -ge 7){
                                                        foreach($letter7 in $alphabet_map_array){
                                                            $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4$letter5$letter6$letter7"
                                                             $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText   
                                                            Write-Host "$letter$letter2$letter3$letter4$letter5$letter6$letter7 : $DecryptedText"
                                                             if($showKey){
                                                                Write-Host $letter$letter2$letter3$letter4$letter5$letter6$letter7
                                                                exit
                                                                    }
                                                            if($maxKeySize -ge 8){
                                                            foreach($letter8 in $alphabet_map_array){
                                                                $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8"
                                                                 $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText   
                                                                Write-Host "$letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8 : $DecryptedText"
                                                                 if($showKey){
                                                                        Write-Host $letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8
                                                                        exit
                                                                                }
                                                                    if($maxKeySize -ge 9){
                                                                    foreach($letter9 in $alphabet_map_array){
                                                                        $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8$letter9"
                                                                         $showKey=Check-Decrypt -knownContentsOfCipher $knownContentsOfCipher -stringDecrypted $DecryptedText
                                                                        Write-Host "$letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8$letter9 : $DecryptedText"
                                                                         if($showKey){
                                                                                    Write-Host $letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8$letter9
                                                                                    exit
                                                                                }
                                                                            if($maxKeySize -ge 10){
                                                                                foreach($letter10 in $alphabet_map_array){
                                                                                $DecryptedText=Decrypt-String -stringToDecrypt $cipherText -key "$letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8$letter9$letter10"
                                                                                $showKey=Check-Decrypt -knownContentsOfCipher $DecryptedText
                                                                                Write-Host "$letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8$letter9$letter10 : $DecryptedText"
                                                                                if($showKey){
                                                                                    Write-Host $letter$letter2$letter3$letter4$letter5$letter6$letter7$letter8$letter9$letter10
                                                                                    exit
                                                                                }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
Write-host Please provide the encoded ciphertext string
$cipherText=Read-Host
#Write-Host $cipherText
#Write-Host Enter Possible Key Length
Write-Host "Please Provided Known Contents"
$knownContentsOfCipher=Read-Host
$knownContentsOfCipher=$knownContentsOfCipher.ToLower()

for($i = 1; $i -le 10; $i=$i+1){
    $StartTime = $(get-date)
    BruteForce -knownContentsOfCipher $knownContentsOfCipher -maxKeySize $i -cipherText $cipherText
    $EndTime = $(get-date) - $StartTime
    $EndTime=$EndTime.TotalSeconds
    Write-Host "Completed in $EndTime seconds. Would you like to continue and increase possible max key length Y or N?"
    $input=Read-Host
    if($input -like "y" -or $input -like "Y"){
        continue
    }
    exit
}


<#
Write-Host Task 1 Vignere Ciphere
Write-Host Type e to encrypt string type d to decrypt string and press enter
$input=Read-Host

if($input -like "e"){
    Write-Host Enter String you would like to encrypt
    $Input=Read-Host
    $Input=$Input.ToLower()
    Write-Host Enter key you would like to encrypt with
    $key=Read-Host
    $key=$key.ToLower()
    Encrypt-String -stringToEncrypt $Input -key $key
}elseif($input -like "d") {
    Write-Host Enter String you would like to decrypt
    $Input=Read-Host
    $Input=$Input.ToLower()
    Write-Host Enter key you would like to decrypt with
    $key=Read-Host
    $key=$key.ToLower()
    Decrypt-String -stringToDecrypt $Input -key $key
}else {
    Write-Host "$input was invalid please try running again"
}
#>
