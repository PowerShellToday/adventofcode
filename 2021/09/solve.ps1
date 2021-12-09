function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    
    $gridMap = foreach ($string in $inputData) {
        , [int[]][string[]][char[]]$string
        
    }
    $xmax = $gridMap.Length - 1 
    $ymax = $gridMap[0].Length - 1
    $Answer = 0
    foreach ($x in 0..$xmax) {
        foreach ($y in 0..$ymax) {
            $Value = $gridMap[$x][$y]
            $up = $x -eq 0 ? $Value + 1 : $gridMap[$x - 1][$y]
            if ($up -le $Value ) {
                Continue
            }
            $down = $x -eq $xmax ? $Value + 1 : $gridMap[$x + 1][$y]
            if ($down -le $Value ) {
                Continue
            }
            $left = $y -eq 0 ? $Value + 1 : $gridMap[$x][$y - 1]
            if ($left -le $Value ) {
                Continue
            }
            $right = $y -eq $ymax ? $Value + 1 : $gridMap[$x][$y + 1]
            if ($right -le $Value ) {
                Continue
            }
            $Answer += $Value + 1
        }
    }
    $Answer

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

