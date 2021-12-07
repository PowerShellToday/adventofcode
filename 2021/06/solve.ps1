class LaternFish {
    [int]$Timer
    [bool]$spawnNew
    LaternFish([int]$Timer) {
        $this.Timer = $Timer
    }
    LaternFish() {
        $this.Timer = 8
    }

    Age() {
        if ($this.Timer -eq 0) {
            $this.Timer = 6
            $this.spawnNew = $true
        }
        else {
            $this.Timer -= 1
            $this.spawnNew = $false
        }
    }
}



function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $fishes = [Collections.Generic.List[LaternFish]]::new()
        [int[]]$ages = $inputData -split ','
        foreach ($age in $ages) {
            $fishes.Add([LaternFish]::new($age))
        }
        
        for ($day = 1; $day -le 80; $day++) {
            foreach ($fish in $fishes) {
                [void]$fish.age()
            }

            $NewFishes = $fishes.where{ $_.spawnNew }.count
            if ($NewFishes -ge 1) {
                1..$NewFishes | ForEach-Object { $fishes.Add([LaternFish]::new()) }
                
            }

            
        }
        "dAy $day"
        $Fishes.count
        
    }
    
    end {
    }
}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$inputData,
        [int]$Days
    )
    
    begin {
    }
    
    process {
        [int[]]$ages = $inputData -split ','
        $fishes = @{}
        foreach ($age in $ages) {
            $fishes[$age] += 1
        }
        1..$Days | ForEach-Object {
            $tmpFishes = @{}

            foreach ($age in $fishes.Keys) {
                if ($age -eq 0) {
                    $tmpFishes[8] += $fishes[$age]
                    $tmpFishes[6] += $fishes[$age]
                } else {
                    $tmpFishes[$age - 1] +=$fishes[$age]
                }
            }
            $fishes = $tmpFishes.Clone()
        }
        ($fishes.Values | Measure-Object -Sum).sum
        
    }
    
    end {
    }
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData -Days 256 

