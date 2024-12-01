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

$startTime = Get-Date

$SenicPoints = foreach ($x in ($minBox..$maxBox)) {
    foreach ($y in ($minBox..$maxBox)) {
        $MyHight = $Trees[$x, $y]
        
        # UP
        $UpPoints = 0
        foreach ($y_Test in (($y + 1)..$max)) {
            $TreeTest = $Trees[$x, $y_Test]
            $UpPoints ++
            if ($TreeTest -ge $MyHight) {
                break
            }
        }

        # Down
        $DownPoints = 0
        foreach ($y_Test in (($y - 1)..$min)) {
            $TreeTest = $Trees[$x, $y_Test]
            $DownPoints ++
            if ($TreeTest -ge $MyHight) {
                break
            }
        }
        
        # Right
        $RightPoints = 0
        foreach ($x_Test in (($x + 1)..$max)) {
            $TreeTest = $Trees[$x_Test, $y]
            $RightPoints ++
            if ($TreeTest -ge $MyHight) {
                break
            }
            
        }
        
        # Left
        $LeftPoints = 0
        foreach ($x_Test in (($x - 1)..$min)) {
            $TreeTest = $Trees[$x_Test, $y]
            $LeftPoints ++
            if ($TreeTest -ge $MyHight) {
                break
            }
        }
        
        $LeftPoints * $RightPoints * $UpPoints * $DownPoints
        
    }
}
$SenicPoints | Measure-Object -Maximum -Sum

$EndTime = Get-Date

New-TimeSpan -Start $startTime -End $EndTime
