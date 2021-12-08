$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt

[bool[, ]]$Lights = (New-Object 'bool[,]' 1000, 1000)
foreach ($line in $inputData) {
    $line -match '^(?<acction>toggle|turn on|turn off)\s(?<xstart>\d+),(?<ystart>\d+)\s\w*\s(?<xend>\d+),(?<yend>\d+)$' | Out-Null
    #$Matches
    #$Matches.xstart..$Matches.xend 

    foreach ($x in $Matches.xstart..$Matches.xend ) {
        foreach ($y in $Matches.ystart..$Matches.yend) {
            switch ($Matches.acction) {
                'turn off' {
                    $Lights[$x,$y] = $false
                }
                'turn on' {
                    $Lights[$x,$y] = $true
                }
                'toggle'
                {
                    $Lights[$x,$y] = -not $Lights[$x,$y]
                }
                Default {}
            }
            
        }
    }
}
$Lights.Where{$_}.count