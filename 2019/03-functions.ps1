function measure-ManhattanDist {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $start,
        [Parameter(Mandatory = $true)]
        [string]
        $end
    )
    [int32]$x1, [int32]$y1 = $start -split ','
    [int32]$x2, [int32]$y2 = $end -split ','

    $D1 = if ($x1 -ge $x2) {
        $x1 - $x2
    }
    else {
        $x2 - $x1
    }
    $D2 = if ($y1 -ge $y2) {
        $y1 - $y2
    }
    else {
        $y2 - $y1
    }
    $D1 + $D2
}

Function Show-Path {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $start,
        [Parameter(Mandatory = $true)]
        [string]
        $instruction
    )
    [int32]$x, [int32]$y = $start -split ','
    $Direction = $instruction.ToUpper().Substring(0, 1)
    [int32]$Length = $instruction.Substring(1)

    switch ($Direction) {
        'R' { 
            (($x + 1)..($x + $Length)).ForEach{ "$_,$y" }
        }
        'L' { 
            (($x - 1)..($x - $Length)).ForEach{ "$_,$y" }
        }
        'U' { 
            (($y + 1)..($y + $Length)).ForEach{ "$x,$_" }
        }
        'D' { 
            (($y - 1)..($y - $Length)).ForEach{ "$x,$_" }
        }
    }
}

function get-closestIntersection {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $wire1,
        [Parameter(Mandatory = $true)]
        [string]
        $wire2
    )
    $w1instructions = $wire1 -split ','
    $w1path = @{ }
    $WStart = '0,0'
    foreach ($w1instruction in $w1instructions) {
        $tmpresult = Show-Path -start $WStart -instruction $w1instruction
        $WStart = $tmpresult[-1]
        $tmpresult.foreach{ $w1path.$_ = 1 }
    }

    $w2instructions = $wire2 -split ','
    $w2path = @{ }
    $WStart = '0,0'
    foreach ($w2instruction in $w2instructions) {
        $tmpresult = Show-Path -start $WStart -instruction $w2instruction
        $WStart = $tmpresult[-1]
        $tmpresult.foreach{ $w2path.$_ = 1 }
    }


    $w1path.keys.where{ $w2path.containskey($_) }.foreach{ measure-ManhattanDist -start '0,0' -end $_ } | Sort-Object | Select-Object -First 1
}



function get-closestIntersectionb {
    param (
        [Parameter(Mandatory = $true)]
        [string]
        $wire1,
        [Parameter(Mandatory = $true)]
        [string]
        $wire2
    )
    get-date | Write-Verbose
    Write-Verbose 'Wire1'
    $w1instructions = $wire1 -split ','
    $w1path = @{ }
    $WStart = '0,0'
    $Step = 0
    foreach ($w1instruction in $w1instructions) {
        $tmpresult = Show-Path -start $WStart -instruction $w1instruction
        $WStart = $tmpresult[-1]
        $tmpresult.foreach{ 
            $Step ++
            if (-not $w1path.ContainsKey($_)) {
                $w1path.$_ = $Step
            }
        }
    }
    Write-Verbose "Wire1 count: $Step"
    get-date | Write-Verbose
    Write-Verbose 'Wire2'
    $Step = 0
    $w2instructions = $wire2 -split ','
    $w2path = @{ }
    $WStart = '0,0'
    foreach ($w2instruction in $w2instructions) {
        $tmpresult = Show-Path -start $WStart -instruction $w2instruction
        $WStart = $tmpresult[-1]
        $tmpresult.foreach{
            $Step ++
            if (-not $w2path.ContainsKey($_)) {
                $w2path.$_ = $Step
            }
        }
    }

    get-date | Write-Verbose
    Write-Verbose 'Crossings'

    $Crossings = foreach ($item in $w1path.GetEnumerator()) {
        if ($w2path.containskey($item.Key)) {
            $w2path[$item.Key] + $item.Value
        }
    }
    $Crossings | Sort-Object | Select-Object -First 1
}