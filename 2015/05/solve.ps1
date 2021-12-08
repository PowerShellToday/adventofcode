function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    
    begin {
    }
    
    process {
        $NiceStrings = 0
        foreach ($line in $inputData) {
            if (
                $line -match '([aeiou]).*([aeiou]).*([aeiou])' -and
                $line -match '(.)\1+' -and
                $line -notmatch '(ab|cd|pq|xy)'
            ) {
                $NiceStrings++
            }
        }
        $NiceStrings
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
        $NiceStrings = 0
        foreach ($line in $inputData) {
            if (
                $line -match '(?<g1>..).*(\k<g1>)' -and
                $line -match '(?<g1>.).(\k<g1>)'
            ) {
                $NiceStrings++
            }
        }
        $NiceStrings
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

