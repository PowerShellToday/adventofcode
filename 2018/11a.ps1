

function Get-FuelCellPower {
    param (
        [string]$Cordinate,
        [int32]$gridserial
    )
    [int32]$x,[int32]$y = $Cordinate -split ','
    $RackId = $x + 10
    $powerlevel = (($RackId * $y) + $gridserial) * $RackId
    $powerlevel = if ($powerlevel -match '(\d)\d\d$') {
        [int32]$Matches[1]
    } else {
        0
    }
    $powerlevel - 5 
}

@'
1,1 2,1 3,1 4,1 5,1
1,2 2,2 3,2 4,2 5,2
1,3 2,3 3,3 4,3 5,3
1,4 2,4 3,4 4,4 5,4
1,5 2,5 3,5 4,5 5,5
1,6 2,6 3,5 6,5 5,6
'@

function Get-SquareCordinates {
    param (
        [string]$Cordinate
    )
    [int32]$x,[int32]$y = $Cordinate -split ','
   foreach ($xx in ($x)..($x + 2)) {
        foreach ($yy in ($y)..($y + 2)) {
            '{0},{1}' -f $xx, $yy
        }
   }
}


$TempHash = @{}
$xMax = 300
$yMax = 300
$gridserial = 3628
foreach  ($yy in 1..$yMax) {
    foreach ($xx in 1..$xMax) {
        $Key = '{0},{1}' -f $xx, $yy
        $Obj = [PSCustomObject]@{
            Compute = ($xx -le ($xMax-2) -and $yy -le ($yMax -2))
            FuelCellPower = Get-FuelCellPower -Cordinate $Key -gridserial $gridserial
            Name = $Key
            SquareSum = 0
        }
        $TempHash.Add($Key,$Obj)
    }
}


foreach ($point in $TempHash.Values) {
    if($point.Compute) {
        $point.SquareSum = (Get-SquareCordinates -Cordinate $point.name | foreach {$TempHash[$_].FuelCellPower} | Measure-Object -Sum).sum
    }
}

($TempHash.Values | Sort-Object SquareSum | Select-Object -Last 1).Name