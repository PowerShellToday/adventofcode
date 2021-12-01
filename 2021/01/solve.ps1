function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Int32[]]$inputData
    )
    
    begin {
        $result = 0
    }
    
    process {
        for ($i = 1; $i -lt $inputData.Count; $i++) {
            if ($inputData[$i] -gt $inputData[$i - 1]) {
                $result++
            }
        }
    }
    
    end {
        $result
    }
}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Int32[]]$inputData
    )
    
    begin {
    }
    
    process {
        $Numbers = for ($i = 0; $i -lt ($inputData.Count - 2); $i++) {
            $Values = $inputData[$i..($i + 2)]
            Write-Debug "Values: $($Values -join ',')"
            ($Values | Measure-Object -Sum).Sum
        }
    }
    
    end {
        Get-Part1 -inputData $Numbers
    }
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData

