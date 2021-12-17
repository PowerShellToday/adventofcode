

$data = 'prod'
#$data = 'test'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt -Raw
$inputData -match '^target area: x=(?<xrange>(-|)\d+\.\.(-|)\d+), y=(?<yrange>(-|)\d+\.\.(-|)\d+)$'
$yrange = Invoke-Expression $Matches['yrange']
$yGoal = $yrange | Measure-Object -Maximum -Minimum
$Speed = [math]::Abs($yGoal.Minimum) - 1
$pos = 0
do {
    $pos = $pos + $Speed
    $Speed -= 1
    
} while ($speed -gt 0)

$pos



break



$inputData -match '^target area: x=(?<xrange>(-|)\d+\.\.(-|)\d+), y=(?<yrange>(-|)\d+\.\.(-|)\d+)$'

$xrange = Invoke-Expression $Matches['xrange']
$yrange = Invoke-Expression $Matches['yrange']
$xGoal = $xrange | Measure-Object -Maximum -Minimum
$xGoal
$yGoal = $yrange | Measure-Object -Maximum -Minimum
$yGoal

$ValidXspeeds = foreach ($xStartSpeed in 1..$xGoal.Maximum) {
    $tmpResult = [PSCustomObject]@{
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
            $tmpResult 
        }
        $speed = $speed - 1
    } until ($speed -lt 0 -or $x -gt $xGoal.Maximum)
}






#$ValidXspeeds | ft -AutoSize