$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Show-Path" {
    It "R2" {
        Show-Path -start '0,0' -instruction 'R2' | Should -Be ('1,0', '2,0')
    }
    It "L2" {
        Show-Path -start '0,0' -instruction 'L2' | Should -Be ('-1,0', '-2,0')
    }
    It "U2" {
        Show-Path -start '0,0' -instruction 'U2' | Should -Be ('0,1', '0,2')
    }
    It "D2" {
        Show-Path -start '0,0' -instruction 'D2' | Should -Be ('0,-1', '0,-2')
    }
}


Describe "measure-ManhattanDist" {
    It "measure-ManhattanDist 0,0 to 1,1" {
        measure-ManhattanDist -start '0,0' -end '1,1' | Should -Be 2
    }
    It "measure-ManhattanDist 1,1 to 0,0" {
        measure-ManhattanDist -start '1,1' -end '0,0' | Should -Be 2
    }
    It "measure-ManhattanDist -1,-1 to 0,0" {
        measure-ManhattanDist -start '-1,-1' -end '0,0' | Should -Be 2
    }
}


Describe "get-closestIntersection" {
    It "get-closestIntersection test 1" {
        get-closestIntersection -wire1 'R8,U5,L5,D3' -wire2 'U7,R6,D4,L4' | Should -Be 6
    }
    It "get-closestIntersection test 2" {
        $wire1 = 'R75,D30,R83,U83,L12,D49,R71,U7,L72'
        $wire2 = 'U62,R66,U55,R34,D71,R55,D58,R83'
        get-closestIntersection -wire1 $wire1 -wire2 $wire2 | Should -Be 159
    }
    It "get-closestIntersection test 3" {
        $wire1 = 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51'
        $wire2 = 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'
        get-closestIntersection -wire1 $wire1 -wire2 $wire2 | Should -Be 135
    }
}

Describe "get-closestIntersection" {
    It "get-closestIntersection test 1" {
        get-closestIntersectionb -wire1 'R8,U5,L5,D3' -wire2 'U7,R6,D4,L4' | Should -Be 30
    }
    It "get-closestIntersection test 2" {
        $wire1 = 'R75,D30,R83,U83,L12,D49,R71,U7,L72'
        $wire2 = 'U62,R66,U55,R34,D71,R55,D58,R83'
        get-closestIntersectionb -wire1 $wire1 -wire2 $wire2 | Should -Be 610
    }
    It "get-closestIntersection test 3" {
        $wire1 = 'R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51'
        $wire2 = 'U98,R91,D20,R16,D67,R40,U7,R15,U6,R7'
        get-closestIntersectionb -wire1 $wire1 -wire2 $wire2 | Should -Be 410
    }
}
