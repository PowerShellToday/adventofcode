function Get-Part1 {
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

