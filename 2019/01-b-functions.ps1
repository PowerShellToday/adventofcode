function Get-FuelCalc {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [decimal[]]
        $Mass
    )
    begin {
        $result = 0
    }
    process {
        $Mass.ForEach{ $result += [math]::Floor($_ / 3) - 2 }
    }
    end {
        if ($result -gt 0) {
            $result
        }
        else {
            0
        }
    }
}

function Get-TotalFuelCalc {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int32[]]
        $Mass
    )
    begin {
        $result = 0
    }
    process {
        foreach ($Massitem in $Mass) {
            $y = $Massitem 
            do {
                $x = Get-FuelCalc -Mass $y 
                $y = $x
                $result += $x
            } while ($x -gt 0)
        }
    }
    end {
        $result
    }
}