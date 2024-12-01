[int32[, ]]$Numbers = (New-Object 'int[,]' 5, 5)

$inputFile = Get-Content .\08_test.txt
$inputFile = Get-Content .\08.txt
$max = $inputFile.Count - 1
$min = 0

$maxBox = $inputFile.Count - 2
$minBox = 1


[int32[, ]]$Trees = (New-Object 'int[,]' $inputFile[0].Length, $inputFile.Length)
[array]::Reverse($inputFile)

foreach ($y in ($min..$max)) {
    foreach ($x in ($min..$max)) {
        $Trees[$x, $y] = [string]$inputFile[$y][$x]
    }
}





$verts = foreach ($x in ($minBox..$maxBox)) {
    #Row left to right
    $high = $Trees[$x, 0]
    'UP'
    foreach ($y in ($minBox..$maxBox)) {
        $CurrentTree = $Trees[$x, $y]
        if ($CurrentTree -le $high) {
            "$x,$y"
        }
        else {
            $high = $CurrentTree
        }
    }
    'DOWN'
    $high = $Trees[$x,$max]
    foreach ($y in ($maxBox..$minBox)) {
        $CurrentTree = $Trees[$x, $y]
        if ($CurrentTree -le $high) {
            "$x,$y"
        }
        else {
            $high = $CurrentTree
        }
    }
}


$horiz = foreach ($y in ($minBox..$maxBox)) {
    #Row left to right
    $high = $Trees[0, $y]
    foreach ($x in ($minBox..$maxBox)) {
        $CurrentTree = $Trees[$x, $y]
        if ($CurrentTree -le $high) {
            "$x,$y"
        }
        else {
            $high = $CurrentTree
        }
    }
    $high = $Trees[$max, $y]
    foreach ($x in ($maxBox..$minBox)) {
        $CurrentTree = $Trees[$x, $y]
        if ($CurrentTree -le $high) {
            "$x,$y"
        }
        else {
            $high = $CurrentTree
        }
    }
}

$hidden = ($horiz + $verts | Group-Object | where  Count -eq 4).Count
($inputFile.Length * $inputFile.Length) - $hidden