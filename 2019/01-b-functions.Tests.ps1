$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"
<#
A module of mass 14 requires 2 fuel. This fuel requires no further fuel (2 divided by 3 and rounded down is 0, which would call for a negative fuel), so the total fuel required is still just 2.
At first, a module of mass 1969 requires 654 fuel. Then, this fuel requires 216 more fuel (654 / 3 - 2). 216 then requires 70 more fuel, which requires 21 fuel, which requires 5 fuel, which requires no further fuel. So, the total fuel required for a module of mass 1969 is 654 + 216 + 70 + 21 + 5 = 966.
The fuel required by a module of mass 100756 and its fuel is: 33583 + 11192 + 3728 + 1240 + 411 + 135 + 43 + 12 + 2 = 50346.

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
$script:total = 0
Describe "Get-TotalFuelCalc" {
    $TestPairs = [ordered]@{
        12     = 2
        1969   = 966
        100756 = 50346
    }
    $TestPairs.GetEnumerator().ForEach{
        It "Test singels number $($_.Name)" {
            $TempRes = Get-TotalFuelCalc -mass $_.Name
            $script:total += $TempRes
            $TempRes | Should -Be $_.Value
        }
    }

    It "Test array of numbers in pipeline" {
        $TempRes = 12, 12 | Get-TotalFuelCalc
        $TempRes | Should -Be 4
    }
    It "Test array of numbers in pipeline" {
        $TempRes = $TestPairs.Keys | Get-TotalFuelCalc
        $TempRes | Should -Be $total
    }

    It "Test array of numbers in param" {
        $TempRes = Get-TotalFuelCalc -Mass $TestPairs.Keys
        $TempRes | Should -Be $total
    }
}
