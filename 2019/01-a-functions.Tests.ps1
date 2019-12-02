$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
<#
For a mass of 12, divide by 3 and round down to get 4, then subtract 2 to get 2.
For a mass of 14, dividing by 3 and rounding down still yields 4, so the fuel required is also 2.
For a mass of 1969, the fuel required is 654.
For a mass of 100756, the fuel required is 33583.

#>
$script:total = 0

Describe "Get-FuelCalc" {
    $TestPairs = [ordered]@{
        12     = 2
        14     = 2
        1969   = 654
        100756 = 33583
    }
    $TestPairs.GetEnumerator().ForEach{
        
        It "Test singels number $($_.Name)" {
            $TempRes = Get-FuelCalc -mass $_.Name
            $script:total += $TempRes
            $TempRes | Should -Be $_.Value
        }
    }

    It "Test array of numbers in pipeline" {
        $TempRes = $TestPairs.Keys | Get-FuelCalc
        $TempRes | Should -Be $total
    }

    It "Test array of numbers in param" {
        $TempRes = Get-FuelCalc -Mass $TestPairs.Keys
        $TempRes | Should -Be $total
    }
}
