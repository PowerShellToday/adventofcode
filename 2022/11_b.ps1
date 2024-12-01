

Function Factorise {
    PARAM ($Number)
    $MaxFactor = [math]::Sqrt($Number)
    #take care of 2 as a factor
    $Factor=2
    while ( ($Number % $Factor) -eq 0) {
        $Factor
        $Number=$Number/$Factor
    }

    #then brute force all odd numbers as factors up to max prime
    #while $Number remains greater than max prime
    $Factor=3
    while ($Factor -le $MaxFactor -and $number -ge $MaxFactor) {
        while ( ($Number % $Factor) -eq 0) {
            $Factor
            $Number=$Number/$Factor
        }
        $Factor+=2
    }
    $Number
}

#Factorise 280
function Simplify {
    param(
        $number
    )
    [int32[]]$primes = 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241, 251, 257, 263, 269, 271, 277, 281, 283, 293, 307, 311, 313, 317, 331, 337, 347, 349, 353, 359, 367, 373, 379, 383, 389, 397, 401, 409, 419, 421, 431, 433, 439, 443, 449, 457, 461, 463, 467, 479, 487, 491, 499, 503, 509, 521, 523, 541, 547, 557, 563, 569, 571, 577, 587, 593, 599, 601, 607, 613, 617, 619, 631, 641, 643, 647, 653, 659, 661, 673, 677, 683, 691, 701, 709, 719, 727, 733, 739, 743, 751, 757, 761, 769, 773, 787, 797, 809, 811, 821, 823, 827, 829, 839, 853, 857, 859, 863, 877, 881, 883, 887, 907, 911, 919, 929, 937, 941, 947, 953, 967, 971, 977, 983, 991, 997
    [int32]$starter = 1
    foreach ($prime in $primes) {
        if($prime -le $number -and -not ($number % $prime)) {
            $starter = $starter * $prime
        }
    }
    [int32]$starter
}


function Simplify2 {
    param(
        [UInt64]$number
    )
    $numbers =  (Factorise $number)
    [int64]$starter = 1
    $numbers =  $numbers | Select-Object -Unique 
    foreach ($number in $numbers) {
        $starter = $starter * $number
    }
    $starter
}

#Factorise 280


class Monkey {
    [string]$Name
    [string]$Operation
    [bigint]$TestDivider
    [System.Collections.ArrayList]$Items = @()
    [string]$TrueReciver
    [string]$FalseReciver
    [int32]$Inspects
    [int32]$LCM

    Monkey([string]$Name, [string]$Operation, [bigint]$TestDivider, [string]$TrueReciver,[string]$FalseReciver) {
        $this.Name = $Name.ToLower()
        $This.Operation = $Operation
        $This.TestDivider = $TestDivider
        $this.TrueReciver = [string]$TrueReciver
        $this.FalseReciver = [string]$FalseReciver
    }
    ReciveItem([bigint]$item) {
        $this.Items.add($item)
    }
    #[string[]] 
    [string[]]StartTurn() {
        [string[]]$Result = @()
        while ($this.Items.Count) {
            $this.Inspects ++
            $CurrentItem = $this.Items[0]
            $this.Items.RemoveAt(0)

            $newValue = switch -regex ($This.Operation) {
                'old \* old' {
                    $CurrentItem * $CurrentItem
                }
                'old \+ (\d+)' {
                    $CurrentItem + [bigint]$Matches[1]
                }
                'old \* (\d+)' {
                    $CurrentItem * [bigint]$Matches[1]
                }
                Default {}
            }
            #[bigint]$newValue = Simplify2 $newValue
            #[int64]$newValue = Simplify $newValue
            if ($newValue -gt 1000000) {
                #[int64]$newValue = Simplify2 $newValue
            }
            #"$newValue = [math]::round(($newValue/3),0,[MidpointRounding]::ToZero) 
            $Result += if (-not ($newValue % $This.TestDivider)) {
                "$($newValue%$this.LCM) => $($this.TrueReciver)"
                #"29900 => $($this.TrueReciver)"
                #"$This.TestDivider => $($this.TrueReciver)"
            } else {
                #[int64]$newValue = Simplify $newValue
                "$($newValue%$this.LCM) => $($this.FalseReciver)"
            }
        }
        return $Result
    }

    [string]ToString(){
        return ("{0} ({1}) {2}" -f $this.Name,$this.Inspects , ($this.Items -join ', '))
    }
}


#[System.Collections.ArrayList]$Items = @()
#$Items.Add(7)|Out-Null
#$Items.Add(9)|Out-Null
#$Items.Add(10)|Out-Null
#$Items.Count
#
#while ($Items.Count) {
#    $Items[0]
#    $Items.RemoveAt(0)
#}



$InputFile = Get-Content .\11_test.txt | % { $_.trim() }
$InputFile = Get-Content .\11.txt | % { $_.trim() }
$InputFile = $InputFile -join '|'

$MonkeyList = [ordered]@{}
foreach ($monkey in $InputFile.Split('||')) {
    $Details = $monkey.Split('|')
    $Name = $Details[0].Replace(':', '').trim().ToLower()
    $Operation = $Details[2].Split('=')[1].trim()
    $TestDivider = $Details[3].Split(' ') | Select-Object -Last 1
    $TrueReciver = $Details[4].Split(' ')[-2..-1] -join ' '
    $FalseReciver = $Details[5].Split(' ')[-2..-1] -join ' '
    $monkey = [Monkey]::new($Name,$Operation,$TestDivider,$TrueReciver,$FalseReciver)
    $Details[1].Split(': ')[1].Split(', ') |% {$monkey.ReciveItem($_)}
    $MonkeyList.Add($Name,$monkey)
}
$MonkeyList.Keys

$lcm  = Invoke-Expression ($MonkeyList.Values.TestDivider -join '*')

foreach ($Monkey in $MonkeyList.Keys){
    $MonkeyList[$monkey].LCM = $lcm 
}


1..10000| % {
    $Turn = $_
    foreach ($Monkey in $MonkeyList.Keys) {
        $MonkeyList[$monkey].StartTurn() | % {
            $_ -match '^(\d+) => (monkey \d+)$' | Out-Null
            #"$Monkey =>"+ $Matches[2] | Write-Output
            $MonkeyList[$Matches[2]].ReciveItem($Matches[1])
            
        }
    }

    $printOut = if ($Turn -eq 1) {
        $True

    } elseif ($Turn -in (20)) {
        $True
    } elseif (-not ($Turn % 1000)) {
        $True
    } else {
        $False
    }
    #$printOut = $False
    if($printOut ){
        "Turn: $turn"
        $MonkeyList
        ''
        ''
    }
}

#$res | Group-Object
$x1,$x2 =  $MonkeyList.Values.Inspects | Sort-Object -Descending | Select-Object -First 2
$x1 * $x2
break
foreach ($Monkey in $MonkeyList.Keys) {
    $MonkeyList[$monkey].StartTurn() | % {
        $_ -match '^(\d+) => (monkey \d+)$' | Out-Null
        $MonkeyList[$Matches[2]].ReciveItem($Matches[1])
        
    }
}
$MonkeyList