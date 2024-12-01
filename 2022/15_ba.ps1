$lines = Get-Content .\15_test.txt
$lineToLook = 10
$minValue = 0
$maxValue = 20
$lines = Get-Content .\15.txt
$minValue = 0
$maxValue = 4000000
$lineToLook = 2000000
#'Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)'


class pair {
    [int32]$Xs
    [int32]$Ys
    [int32]$Xb
    [int32]$Yb
    [int32]$Ymax
    [int32]$Ymin
    [int32]$Xmax
    [int32]$Xmin
    [int32]$Radius
    [int32]$AreaMaxX
    [int32]$AreaMinX
    [int32]$AreaMaxY
    [int32]$AreaMinY

    pair ([int32]$Xs, [int32]$Ys, [int32]$Xb, [int32]$Yb) {
        $this.Xs = $Xs
        $this.Ys = $Ys
        $this.Xb = $Xb
        $this.Yb = $Yb
        if ($Xs -gt $Xb) {
            $this.Xmax = $Xs
            $this.Xmin = $Xb
        }
        else {
            $this.Xmax = $Xb
            $this.Xmin = $Xs
        }
        if ($Ys -gt $Yb) {
            $this.Ymax = $Ys
            $this.Ymin = $Yb
        }
        else {
            $this.Ymax = $Yb
            $this.Ymin = $Ys
        }
        $this.Radius = [math]::abs($this.Ys - $this.Yb) + [math]::abs($this.Xs - $this.Xb)
        $this.AreaMaxX = $this.Xs + $this.Radius
        $this.AreaMinX = $this.Xs - $this.Radius
        $this.AreaMaxY = $this.Ys + $this.Radius
        $this.AreaMinY = $this.Ys - $this.Radius
    }
}





$pairs = foreach ($line in $lines) {
    $line -match 'Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)' | Out-Null
    [int32]$Xs = $Matches[1]
    [int32]$Ys = $Matches[2]
    [int32]$Xb = $Matches[3]
    [int32]$Yb = $Matches[4]
    $pair = [pair]::new($Xs, $Ys, $Xb, $Yb)
    $pair
    #[PSCustomObject]@{
    #    x = $pair.Xs
    #    y = $pair.Ys
    #    VertexRadius = ($pair.Radius + 1)
    #}
}

$Vertex = @{}


#$pairs | select xs, ys, Radius
$res = $pairs | Foreach-Object -ThrottleLimit 10 -Parallel {
    $curretntPair = $_
    $xStart = ($curretntPair.AreaMinX - 1) -ge $using:minValue ? ($curretntPair.AreaMinX - 1) : $using:minValue
    $xStop = ($curretntPair.AreaMaxX + 1) -le $using:maxValue ? ($curretntPair.AreaMaxX + 1) : $using:maxValue
    
    foreach ($x in $xStart..$xStop) {
        $DistanceToLine = [math]::abs($curretntPair.Xs - $x)
        [int32]$spread = $curretntPair.Radius - $DistanceToLine + 1
        if ($spread) {
            [int32]$bigY = $curretntPair.Ys + $spread
            [int32]$smallY = $curretntPair.Ys - $spread
            if ($bigY -le $using:maxValue -and $bigY -ge $using:minValue) {
                , ($x, $bigY)
            }
            if ($smallY -le $using:maxValue -and $smallY -ge $using:minValue) {
                , ($x, $smallY)
            }
        }
        else {
            if ($curretntPair.Ys -le $using:maxValue -and $curretntPair.Ys -ge $using:minValue) {
                , ($x, $($curretntPair.Ys))
            }
        }
    }
    #Action that will run in Parallel. Reference the current object via $PSItem and bring in outside variables with $USING:varname
}
'Vertex done'
#$res.ForEach{ $Vertex[$_ -join ',']++ }
$res.count


$vertex2 = @{}
0..4000000 | % { $vertex2[$_] = @{} }
'start Adding'
$res | % {
    $vertex2[$_[0]][$_[1]]++
}


$tests = 0..4000000  | % {
    $x = $_
    $vertex2[$x].keys | % {
        $y = $_
        if ($vertex2[$x][$y] -ge 3) {
            "$x,$y"
        }
    }
}



#$tests = '1571098,2282563','1581950,2271709','1581951,2271710','1581951,2271708','1581952,2271709','1630797,2222862','1682024,2371781','1738355,2115304','2215504,3723553','2229474,3709583','2381860,3557197','2638485,2650264','2791269,2803048','2859208,1957661','2882445,1934422','2882446,1934423','2998763,1818106','3133845,3162634','3133846,3162635'
foreach ($test in $tests) {
    [int32]$x, [int32]$y = $test -split ','
    $free = $true
    foreach ($curretntPair in $pairs) {
        $distance = [math]::abs($curretntPair.Ys - $y) + [math]::abs($curretntPair.Xs - $x)
        if ($distance -le $curretntPair.Radius) {
            $free = $false
            break
        }
    }
    if ($free) {
        ($x * 4000000) + $y
        $test
    }
}

