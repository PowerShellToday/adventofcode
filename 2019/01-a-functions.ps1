<#
For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
For a mass of 1969, the fuel required is 654.
For a mass of 100756, the fuel required is 33583.

#>

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
        $result
    }
}