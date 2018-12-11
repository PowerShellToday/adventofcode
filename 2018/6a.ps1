

# Not working

$point = 5, 5
$r = 2

$xFactor = 0

function Get-TaxiCircle ($Center, $Radius, $Filled = $False)
{
    for ($x = ($Center[0] + $Radius); $x -ge ($Center[0] - $Radius) ; $x--)
    {

        $currentR = [math]::Abs($Center[0] - $x)
        $Spread = [math]::Abs($Radius - $currentR)
        if ($Spread)
        {
            $start = ($Center[0] - $Spread)
            $end = ($Center[0] + $Spread)
            $range = if ($filled)
            {
                $start..$end
            }
            else
            {
                $start, $end
            }
            $range | ForEach-Object {
                #, @($x, $_)
                '{0}-{1}' -f $x, $_
            }
        }
        else
        {
            if ($Radius)
            {
                #, @($x, $Center[0])
                '{0}-{1}' -f $x, $Center[1]
            }
            else
            {
                #, @(, @($x, $Center[0]))
                '{0}-{1}' -f $x, $Center[1]
            }
        }
    }
}
#(Get-TaxiCircle -Center 1, 6 -r 2)
#break

# The Taxicab distance between 6,2  and 3,7  would be  |3-6| +| 7-2 |= 3+5 = 8
$Cordinates1 = '1, 1',
'1, 6',
'8, 3',
'3, 4',
'5, 5',
'8, 9'


#$Cordinates1 = '2, 5', '2, 7' , '2, 9'


#$Cordinates1 = Get-Content $PSScriptRoot\6_input.txt #| forEach-Object {iex $_}

$Cordinates = $Cordinates1.ForEach{
    [int32]$x, [int32]$y = ($_ -split ',')
    , ($x, $y)
}

function Get-TaxiDistance ($P1, $P2)
{
    [PSCustomObject]@{
        Distance = [math]::Abs($P1[0] - $P2[0]) + [math]::Abs($P1[1] - $P2[1])
        p1 = $p1
        p2 = $p2

    }
}

$XStats = $Cordinates.ForEach{$_[0]} | Measure-Object -Maximum -Minimum
$YStats = $Cordinates.ForEach{$_[1]} | Measure-Object -Maximum -Minimum


#$array2 = New-Object 'object[,]' $XStats, $YStats

$masterHash = @{}
foreach ($Cordinate in $Cordinates)
{
    $CordinateName = '{0}-{1}' -f $Cordinate[0], $Cordinate[1]
    $masterHash[$CordinateName] = [pscustomobject]@{
        Cordinate = $Cordinate
        Area = 0
        Edge = $false
    }
}

for ($x = $XStats.Minimum; $x -le $XStats.Maximum; $x++)
{
    for ($y = $YStats.Minimum; $Y -le $YStats.Maximum; $Y++)
    {
        $CurrentPoint = $x, $y
        if ($x -in $XStats.Minimum, $XStats.Maximum -or $y -in $YStats.Minimum, $YStats.Maximum )
        {
            $Edge = $true
        }
        else
        {
            $Edge = $false
        }
        $Myradius = 0
        do
        {
            $Circle = Get-TaxiCircle -Center $CurrentPoint -Radius $Myradius
            $FoundPoints = $Circle | where {$masterHash.ContainsKey($_) }
            $Myradius++
        } until ($FoundPoints)
        #$Distances = foreach ($Cordinate in $Cordinates)
        #{
        #    $P1 = $CurrentPoint
        #    $P2 = $Cordinate
        #    [PSCustomObject]@{
        #        Distance = [math]::Abs($P1[0] - $P2[0]) + [math]::Abs($P1[1] - $P2[1])
        #        p1 = $p1
        #        p2 = $p2
        #
        #    }
        #}
        $FoundPoints -join '    '
        #'========='
        if ($FoundPoints)
        {
            $masterHash[$FoundPoints].Area ++
            if ($Edge)
            {
                $masterHash[$FoundPoints].Edge = $true
            }
        }
    }
}

($masterHash.GetEnumerator().foreach{$_.value} | where {-not $_.edge} | Sort Area -Descending)[0].area
$masterHash.GetEnumerator().foreach{$_.value}