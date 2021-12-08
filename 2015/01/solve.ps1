function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $HashTable = [char[]]$inputData[0] | Group-Object -AsHashTable
        $HashTable[[char]'('].count - $HashTable[[char]')'].count
        
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
        $floor = 0
        $charcount = 1
        foreach ($char in [char[]]$inputData[0]) {
            $char -eq '(' ? $floor++ : $floor-- | Out-Null
            if ($floor -eq -1) {
                $charcount
                break
            }
            $charcount++
        }
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

