
$data = 'prod'
#$data = 'test'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt -Raw

$inputData -match '^target area: x=(?<xrange>(-|)\d+\.\.(-|)\d+), y=(?<yrange>(-|)\d+\.\.(-|)\d+)$'

$xrange = Invoke-Expression $Matches['xrange']
$yrange = Invoke-Expression $Matches['yrange']
$xGoal = $xrange | Measure-Object -Maximum -Minimum
$yGoal = $yrange | Measure-Object -Maximum -Minimum

$ValidXspeeds = foreach ($xStartSpeed in 1..$xGoal.Maximum) {
    $tmpResult = @{
        xStartSpeed = [int32]$xStartSpeed
        Steps       = [int32[]]@()
        StepCount   = 0
        Speed       = 0
    }
    $x = 0
    $speed = $xStartSpeed
    do {
        $x = $x + $speed
        $tmpResult.Steps += $x
        if ($x -ge $xGoal.Minimum -and $x -le $xGoal.Maximum) {
            $tmpResult.Speed = $speed
            $tmpResult.StepCount = $tmpResult.Steps.Count
            [PSCustomObject]$tmpResult 
        }
        $speed = $speed - 1
    } until ($speed -lt 0 -or $x -gt $xGoal.Maximum)
}


$yMaxSpeed = [math]::Abs($yGoal.Minimum) - 1

$ValidYspeeds = foreach ($yStartSpeed in $yGoal.Minimum..$yMaxSpeed) {
    $tmpResult = @{
        yStartSpeed = [int32]$yStartSpeed
        Steps       = [int32[]]@()
        StepCount   = 0
    }
    $y = 0
    $speed = $yStartSpeed
    do {
        $y = $y + $speed
        $tmpResult.Steps += $y
        if ($y -ge $yGoal.Minimum -and $y -le $yGoal.Maximum) {
            $tmpResult.StepCount = $tmpResult.Steps.Count
            [PSCustomObject]$tmpResult
        }
        $speed = $speed - 1
    } until ($y -lt $yGoal.Minimum)
}


$ValidXspeeds = $ValidXspeeds | Select-Object xStartSpeed, StepCount , speed -Unique

$resultas = foreach ($ValidXspeed in $ValidXspeeds) {
    $Ystarts = if ($ValidXspeed.Speed -eq 0) {
        $ValidYspeeds.where{ $_.StepCount -ge $ValidXspeed.StepCount } 
    }
    else {
        $ValidYspeeds.where{ $_.StepCount -eq $ValidXspeed.StepCount }
    }
    foreach ($Ystart in $Ystarts) {
        '{0},{1}' -f $ValidXspeed.xStartSpeed, $Ystart.yStartSpeed
    }
}
$resultas | Sort-Object | Select-Object -Unique | Measure-Object 
