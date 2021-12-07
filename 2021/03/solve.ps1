function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $tmpresult = @{}
        for ($i = 0; $i -lt ($inputData[0].Length); $i++) {
            $tmpresult[$i] = foreach ($line in $inputData) {
                $line[$i]
            }
        }
        $Gamma = foreach ($Key in ($tmpresult.Keys|Sort-Object)) {
            ($tmpresult[$Key] | Group-Object | Sort-Object -Descending -Property count)[0].Name
        }
        $Gamma = $Gamma -join ''
        $epsilon  = foreach ($Key in ($tmpresult.Keys|Sort-Object)) {
            ($tmpresult[$Key] | Group-Object | Sort-Object -Descending -Property count)[1].Name
        }
        $epsilon  = $epsilon  -join ''
        
        [Convert]::ToInt32($epsilon, 2) * [Convert]::ToInt32($Gamma, 2)
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
        $O = Get-Oxygen -inputData $inputData
        $co2 = Get-Co2 -inputData $inputData
        [Convert]::ToInt32($O, 2) * [Convert]::ToInt32($Co2, 2)
    }
    
    end {
    }
}

function Get-Oxygen {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $tmpresult = @{}
        [string]$regex = '^'
        for ($i = 0; $i -lt ($inputData[0].Length); $i++) {
            $Lines = $inputData.Where{$_ -match $regex}
            if ($Lines.count -eq 1) {
                $Lines
            }
            $posdata = foreach ($line in $Lines) {
                $line[$i]
            }
            $CompareData = $posdata | Group-Object 
            $regex += if ($CompareData[0].count -gt $CompareData[1].count) {
                $CompareData[0].Name
            } elseif ($CompareData[0].count -lt $CompareData[1].count) {
                $CompareData[1].Name
            } else {
                '1'
            }
        }
        $regex -replace '\^',''
    }
    
    end {
    }
}

function Get-Co2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $tmpresult = @{}
        [string]$regex = '^'
        for ($i = 0; $i -lt ($inputData[0].Length); $i++) {
            $Lines = $inputData.Where{$_ -match $regex}

            $posdata = foreach ($line in $Lines) {
                $line[$i]
            }
            $CompareData = $posdata | Group-Object 
            $regex += if ($CompareData[0].count -gt $CompareData[1].count) {
                $CompareData[1].Name
            } elseif ($CompareData[0].count -lt $CompareData[1].count) {
                $CompareData[0].Name
            } else {
                '0'
            }
            if ($Lines.count -eq 1) {
                #$Lines
                $regex = $Lines
                $i = $inputData[0].Length + 7
            }
        }
        $regex -replace '\^',''
    }
    
    end {
    }
}
$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
#Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData 

