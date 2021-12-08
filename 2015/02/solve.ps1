function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $sqFeet = 0
        foreach ($line in $inputData) {
            [int[]]$sides = $line.trim() -split 'x' #| Sort-Object
            [array]::Sort($sides)
            $sqFeet += ($sides[0] * $sides[1] * 3) + ($sides[1] * $sides[2] * 2) + ($sides[0] * $sides[2] * 2)
        }
        $sqFeet
    }
    
    end {
    }
}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $ribbonFeet = 0
        foreach ($line in $inputData) {
            [int[]]$sides = $line.trim() -split 'x' #| Sort-Object
            [array]::Sort($sides)
            $ribbonFeet += ($sides[0]*2) +  ($sides[1]*2) + ($sides[0] * $sides[1] * $sides[2]) 
        }
        $ribbonFeet
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
Get-Part2 -inputData $inputData

