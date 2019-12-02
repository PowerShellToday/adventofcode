$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

<#
1,9,10,3,2,3,11,0,99,30,40,50
3500,9,10,70,2,3,11,0,99,30,40,50

1,0,0,0,99 becomes 2,0,0,0,99 (1 + 1 = 2).
2,3,0,3,99 becomes 2,3,0,6,99 (3 * 2 = 6).
2,4,4,5,99,0 becomes 2,4,4,5,99,9801 (99 * 99 = 9801).
1,1,1,4,99,5,6,0,99 becomes 30,1,1,4,2,5,6,0,99.
#>


Describe "restore-Intcode" {
    $TestPairs = [ordered]@{
        (1, 0, 0, 0, 99)                           = (2, 0, 0, 0, 99)
        (2, 3, 0, 3, 99)                           = (2, 3, 0, 6, 99)
        (2, 4, 4, 5, 99, 0)                        = (2, 4, 4, 5, 99, 9801)
        (1, 1, 1, 4, 99, 5, 6, 0, 99)              = (30, 1, 1, 4, 2, 5, 6, 0, 99)
        (1, 0, 0, 0, 99, 1, 2, 3, 1, 1, 2, 3)      = (2, 0, 0, 0, 99, 1, 2, 3, 1, 1, 2, 3)
        (1, 9, 10, 3, 2, 3, 11, 0, 99, 30, 40, 50) = (3500, 9, 10, 70, 2, 3, 11, 0, 99, 30, 40, 50)

    }
    $TestPairs.GetEnumerator().ForEach{
        
        It "Test singels number $($_.Name)" {
            $TempRes = restore-Intcode -optocode $_.Name  -Verbose  
            $TempRes | Should -Be $_.Value
        }
    }
}
