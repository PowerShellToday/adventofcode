$lines = Get-Content .\15_test.txt
$lineToLook = 10

$lines = Get-Content .\15.txt
$lineToLook = 2000000
'Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)'


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
    $line -match 'Sensor at x=(-*\d+), y=(-*\d+): closest beacon is at x=(-*\d+), y=(-*\d+)'
    [int32]$Xs = $Matches[1]
    [int32]$Ys = $Matches[2]
    [int32]$Xb = $Matches[3]
    [int32]$Yb = $Matches[4]
    [pair]::new($Xs, $Ys, $Xb, $Yb)
}



[int32[]]$beaconsOnLine = $pairs.Yb | Where-Object { $_ -eq $lineToLook } | Select-Object -Unique
[int32[]]$SensorsOnLine = $pairs.Ys.Where{ $_ -eq $lineToLook } | Select-Object -Unique

$matchingPairs = $pairs | Where-Object { $lineToLook -in ($_.AreaMinY..$_.AreaMaxY) }

$ScansOnLineHash =@{}
foreach ($curretntPair in $matchingPairs) {
    '-'| Write-Host
    $DistanceToLine = [math]::abs($curretntPair.Ys - $lineToLook)
    $RadiusOnLine = $curretntPair.Radius - $DistanceToLine
    ($curretntPair.Xs - $RadiusOnLine)..($curretntPair.Xs + $RadiusOnLine) |% {$ScansOnLineHash[$_]=1  }
}




$beaconsOnLine.Where{$ScansOnLineHash.ContainsKey($_)}.foreach{$ScansOnLineHash.Remove($_)}
$ScansOnLineHash.Count
break

#($SensorsOnLine + $ScansOnLine | Sort-Object | Select-Object -Unique).Count - $beaconsOnLine.Count 
<#

Name                           Value
----                           -----
4                              3
3                              15
2                              1
1                              20
0                              Sensor at x=20, y=1: closest beacon is at x=15, y=3
#>


break
$curretntPair = $matchingPairs[1]
$lineToLook = 7
$DistanceToLine = [math]::abs($curretntPair.Ys - $lineToLook)
$RadiusOnLine = $curretntPair.Radius - $DistanceToLine
($curretntPair.Xs - $RadiusOnLine)..($curretntPair.Xs + $RadiusOnLine)