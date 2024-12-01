class Monkey {
    [string]$Name
    [string]$Operation
    [int32]$TestDivider
    [System.Collections.ArrayList]$Items = @()
    [string]$TrueReciver
    [string]$FalseReciver
    [int32]$Inspects

    Monkey([string]$Name, [string]$Operation, [int32]$TestDivider, [string]$TrueReciver,[string]$FalseReciver) {
        $this.Name = $Name.ToLower()
        $This.Operation = $Operation
        $This.TestDivider = $TestDivider
        $this.TrueReciver = [string]$TrueReciver
        $this.FalseReciver = [string]$FalseReciver
    }
    ReciveItem([int32]$item) {
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
                    $CurrentItem + [int32]$Matches[1]
                }
                'old \* (\d+)' {
                    $CurrentItem * [int32]$Matches[1]
                }
                Default {}
            }
            $newValue = [math]::round(($newValue/3),0,[MidpointRounding]::ToZero) 
            $Result += if (-not ($newValue % $This.TestDivider)) {
                "$newValue => $($this.TrueReciver)"
            } else {
                "$newValue => $($this.FalseReciver)"
            }
        }
        return $Result
    }

    [string]ToString(){
        return ("{0} ({1}) - {2}" -f $this.Name,$this.Inspects, ($this.Items -join ', '))
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


1..20 | % {
    "Turn $_"
    foreach ($Monkey in $MonkeyList.Keys) {
        $MonkeyList[$monkey].StartTurn() | % {
            $_ -match '^(\d+) => (monkey \d+)$' | Out-Null
            $MonkeyList[$Matches[2]].ReciveItem($Matches[1])
            
        }
    }
    $MonkeyList
    ''
}
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