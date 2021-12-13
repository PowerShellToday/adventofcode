function write-paper {
    param (
        [bool[, ]]$paper
    )
    ''
    foreach ($y in 0..$paper.GetUpperBound(1)) {
        $row = foreach ($x in 0..$paper.GetUpperBound(0)) {
            $paper[$x, $y] ? '@':' '
        }
        $row -join ''
    }
    ''
}

function compress-paper {
    param (
        [bool[, ]]$paper,
        [int]$fold,
        [ValidateSet('X', 'Y')]
        [string]$foldDirection
    )
    $newPaper = if ($foldDirection -eq 'Y') {
        ,[bool[, ]]::new($paper.GetLength(0), $fold)
    } else {
        ,[bool[, ]]::new($fold, $paper.GetLength(1))
    }
    foreach ($y in 0..$newPaper.GetUpperBound(1)) {
        foreach ($x in 0..$newPaper.GetUpperBound(0)) {
            if ($foldDirection -eq 'Y') {
                $newPaper[$x, $y] = $paper[$x, $y] -or $paper[$x, ($paper.GetUpperBound(1) - $y)]
            } else {
                $newPaper[$x, $y] = $paper[$x, $y] -or $paper[($paper.GetUpperBound(0) - $x), $y]
            }
        }
    }
    ,[bool[, ]]$newPaper.Clone()
}

$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt

$lastcoordinate = [array]::IndexOf($inputData, '') - 1 

$points = foreach ($line in $inputData[0..$lastcoordinate]) {
    [int]$x, [int]$y = $line -split ','
    , ($x, $y)
}
$xSize = ($points.ForEach{ $_[0] } | Measure-Object -Maximum).Maximum + 1
$ySize = ($points.ForEach{ $_[1] } | Measure-Object -Maximum).Maximum + 1

$paper = [bool[, ]]::new($xSize, $ySize)
foreach ($point in $points) {
    $paper[$point] = $true
}

$firstinstruction = [array]::IndexOf($inputData, '') + 1 

$direction, [int]$value = $inputData[$firstinstruction].replace('fold along ', '') -split '='

$paper1 = compress-paper -paper $paper -foldDirection $direction -fold $value
'Answer 1: {0}' -f $paper1.where{ $_ }.count

$inputData[$firstinstruction..$inputData.length] | ForEach-Object {
    $direction, [int]$value = $_.replace('fold along ', '') -split '='
    $paper = compress-paper -paper $paper -foldDirection $direction -fold $value
}
''
'Answer 2:'
write-paper -paper $paper
