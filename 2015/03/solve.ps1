function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$inputData
    )
    
    begin {
        $startX = 0
        $startY = 0
        $visited = @('0,0')
        $visited += foreach ($direction in [char[]]$inputData) {
            switch ($direction) {
                '>' { $startX++ }
                '<' { $startX-- }
                '^' { $startY++ }
                'v' { $startY-- }
                Default {}
            }
            "$startX,$startY"
        }
        ($visited | Sort-Object -Unique).count
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
        [string]$inputData
    )
    
    begin {
    }
    
    process {
        $startX = 0
        $startY = 0
        $visited = @('0,0')
        [char[]]$array = $inputData
        #$visited += foreach ($direction in [char[]]$inputData) {
        $visited += for ($i = 0; $i -lt $array.Count; $i+=2) {
            $direction = $array[$i]
            switch ($direction) {
                '>' { $startX++ }
                '<' { $startX-- }
                '^' { $startY++ }
                'v' { $startY-- }
                Default {}
            }
            "$startX,$startY"
        }

        $startX = 0
        $startY = 0
        $visited += for ($i = 1; $i -lt $array.Count; $i+=2) {
            $direction = $array[$i]
            switch ($direction) {
                '>' { $startX++ }
                '<' { $startX-- }
                '^' { $startY++ }
                'v' { $startY-- }
                Default {}
            }
            "$startX,$startY"
        }

        ($visited | Sort-Object -Unique).count
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

