$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt

[int[, ]]$Lights = (New-Object 'int[,]' 1000, 1000)
foreach ($line in $inputData) {
    $line -match '^(?<acction>toggle|turn on|turn off)\s(?<xstart>\d+),(?<ystart>\d+)\s\w*\s(?<xend>\d+),(?<yend>\d+)$' | Out-Null
    foreach ($x in $Matches.xstart..$Matches.xend ) {
        foreach ($y in $Matches.ystart..$Matches.yend) {
            switch ($Matches.acction) {
                'turn off' {
                    if ($Lights[$x,$y] -ge 1) {
                        $Lights[$x,$y]--
                    }
                }
                'turn on' {
                    $Lights[$x,$y]++
                }
                'toggle'
                {
                    $Lights[$x,$y] += 2
                }
                Default {}
            }
            
        }
    }
}
($Lights| Measure-Object -Sum).Sum