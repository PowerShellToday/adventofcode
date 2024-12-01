
$lines = Get-Content .\14.txt
#$lines = Get-Content .\14_test.txt


#$lines
''
''
class point {
    [string]$x
    [string]$y
    [string]$name
    [string]$Symbol
    [string]$format
    point([string]$name, [char]$Symbol, [string]$format) {
        $this.Symbol = $format + $Symbol + "`e[0m" 
        $this.name = $name
        $this.x, $this.y = $name -split ','
    }
}


class grain {
    [string]$x
    [string]$y
    [string]$name
    [string]$Symbol
    #[string]$format
    [string[]]$paths
    grain([string]$name, [string]$format) {
        $this.Symbol = $format + 'X' + "`e[0m" 
        $this.name = $name
        $this.x, $this.y = $name -split ','
        $this.setPaths()
    }
    setPaths() {
        $y1 = [int32]$this.y + 1
        $this.paths = 0, -1, 1 | % {
            '{0},{1}' -f ([int32]$this.x + $_), $y1
        }
    }
    move($target) {
        $this.x, $this.y = $target -split ','
        $this.setPaths()
        $this.name = $target
    }
}



function Connect-Dots {
    param (
        $from,
        $to
    )
    $x1, $y1 = $from -split ','
    $x2, $y2 = $to -split ','
    if ($x1 -ne $x2) {
        foreach ($x in ($x1..$x2)) {
            "$x,$y1"
        }
    }
    if ($y1 -ne $y2) {
        foreach ($y in ($y1..$y2)) {
            "$x1,$y"
        }
    }
}





function print-grid {
    param (
        $grid
    )
    $yMin = -2
    $yMax = ($grid.Values | Measure-Object -Property y -Maximum ).Maximum + 2
    $xStats = ($grid.Values | Measure-Object -Property x -Maximum -Minimum )
    $xMin = $xStats.Minimum - 2
    $xMax = $xStats.Maximum + 2
    foreach ($PrintY in ($yMin..$yMax)) {
        $line = foreach ($PrintX in ($xMin..$xMax)) {
            #$grid.ContainsKey("$PrintX,$PrintY") ? ( $PSStyle.Reverse + $grid["$PrintX,$PrintY"].Symbol + $PSStyle.Reset) : '.'
            $grid.ContainsKey("$PrintX,$PrintY") ? $grid["$PrintX,$PrintY"].Symbol : '.'
        }
        $line -join ''
    }
    
}



$grid = @{}
$point = [point]::new('500,0', '@', "`e[94m")
$grid[$point.name] = $point
foreach ($line in $lines) {
    $points = $line -split ' -> '
    for ($i = 1; $i -lt $points.Count; $i++) {
        (Connect-Dots $points[$i - 1] $points[$i] ) | ForEach-Object {
            $point = [point]::new($_, '#', "`e[7m")
            $grid[$point.name] = $point
        }
    }
}
$yMin = -2
$yMax = ($grid.Values | Measure-Object -Property y -Maximum ).Maximum 
$counter = 0
while ($true) {
    
#}
#0..10000 | % {
    $pathTraveld = @{}
    $grain = [grain]::new('500,0', "`e[93m")
    #$tracker = [grain]::new('500,0', "`e[35m")
    do {
        $moving = $false
        foreach ($path in $grain.paths) {
            if (-not $grid.ContainsKey($path)) {
                $grain.move($path)
                $tracker.move($path)
                $pathTraveld[$path] = [grain]::new('500,0', "`e[35m")
                $moving = $true
                break
            }
        } 
    
    } while (
        $moving -and ([int32]$grain.y -le $yMax)
    )

    $counter ++
    if ([int32]$grain.y -eq 0) {
        break
    }
    $grid[$grain.name] = $grain
    #print-grid $grid.Clone()
    if (-not ($counter % 1000)) {
        $test = $grid.Clone()
        $pathTraveld.Keys | % {
            $test[$_] = $pathTraveld[$_]
        }
        print-grid $test
        <# Action to perform if the condition is true #>
        ''
        ''
        ''
    }

}
#print-grid $grid.Clone()
''
''


$test = $grid.Clone()

$pathTraveld.Keys | % {
    $test[$_] = $pathTraveld[$_]
}
print-grid $test
$counter | Write-Host