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