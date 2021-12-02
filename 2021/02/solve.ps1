function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
        $AsHash = $inputData | Group-Object -AsHashTable -Property Direction
    }
    
    process {
        $Forward = ($AsHash.forward.value | Measure-Object -sum).Sum
        $up = ($AsHash.up.value | Measure-Object -sum).Sum
        $down = ($AsHash.down.value | Measure-Object -sum).Sum
        ($down - $up) * $Forward

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
        $depth = 0
        $horizontal = 0
        $aim = 0
    }
    
    process {
        foreach ($item in $inputData) {
            Write-Debug ""
            Write-Debug "Input $($item.Direction) and $($item.Value)"

            
            switch ($item.Direction) {
                'forward' {
                    $horizontal += $item.value
                    $depth = $depth + ($aim * $item.value)
                }
                'up' {
                    $aim = $aim - $item.value
                }
                'down' {
                    $aim = $aim + $item.value
                }
                Default {}
            }
            Write-Debug "Depth = $Depth"
            Write-Debug "horizontal = $horizontal"
            Write-Debug "aim = $aim"
            
        }
    }
    
    end {
        $depth * $horizontal
    }
}


$data = 'test'
$data = 'prod'

#$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
$inputData = Import-Csv -Path $PSScriptRoot/input_$data.txt -Delimiter ' ' -Header 'Direction', 'Value'

'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData 

