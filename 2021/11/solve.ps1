class point {
    [int]$X
    [int]$Y
    [int]$Value
    [string[]]$neighbors

    point([int]$X, [int]$Y, [int]$Value) {
        $this.X = $X
        $this.Y = $Y
        $this.Value = $Value
        [string[]]$return = @()
        $maxX = 10
        $maxY = 10
        if ($this.X -lt $maxX) {
            $return = '{0},{1}' -f ($this.X + 1), ($this.Y)
        }
        if ($this.X -lt $maxX -and $this.Y -lt $maxY) {
            $return += '{0},{1}' -f ($this.X + 1), ($this.Y + 1)
        }
        if ($this.X -lt $maxX -and $this.Y -gt 1) {
            $return += '{0},{1}' -f ($this.X + 1), ($this.Y - 1)
        }
        if ($this.X -gt 1) {
            $return += '{0},{1}' -f ($this.X - 1), ($this.Y)
        }
        if ($this.X -gt 1 -and $this.Y -lt $maxY) {
            $return += '{0},{1}' -f ($this.X - 1), ($this.Y + 1)
        }
        if ($this.X -gt 1 -and $this.Y -gt 1) {
            $return += '{0},{1}' -f ($this.X - 1), ($this.Y - 1)
        }
        if ($this.Y -lt $maxY) {
            $return += '{0},{1}' -f ($this.X), ($this.Y + 1)
        }
        if ($this.Y -gt 1) {
            $return += '{0},{1}' -f ($this.X), ($this.Y - 1)
        }
        $this.neighbors = $return
    }
    [string]ToString() {
        Return ("{0},{1}" -f $this.X , $this.Y)
    }
}


function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    $points = @{}
    foreach ($X in 0..9) {
        foreach ($Y in 0..9) {
            $point = [point]::new($X + 1, $Y + 1, [int][string]($inputData[$X][$Y]))
            $points.add([string]$point, $point)
        }
    }

    function print-points {
        foreach ($X in 1..10) {
            $row = foreach ($Y in 1..10) {
                [string]$point = '' + $X + ',' + $Y
                if ($points[$point].value -eq 0) {
                    $PSStyle.Foreground.Yellow 
                    $points[$point].value
                    $PSStyle.Reset
                }
                else {
                    $points[$point].value
                }
                
            }
            -join $row
        }
    }

    function BumpPoint ([string]$point) {
        $points[$point].value ++ 
        if ($points[$point].value -eq 10) {
            foreach ($neighbor in $points[$point].neighbors) {
                BumpPoint -point $points[$neighbor]
            }
        }
    }
    $FlashCount = 0
    foreach ($step in 1..100) {
        foreach ($p in $points.GetEnumerator()) {
            BumpPoint -point $p.value
        }
        $Flashes = $points.GetEnumerator().Where{ $_.Value.Value -gt 9 }
        $FlashCount += $Flashes.Count
        $points.GetEnumerator().Where{ $_.Value.Value -gt 9 }.foreach{ $_.value.value = 0 }

        if($VerbosePreference) {
            ''
            "Step $step"
            print-points
            ''
        }
    }
    $FlashCount
}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    $points = @{}
    foreach ($X in 0..9) {
        foreach ($Y in 0..9) {
            $point = [point]::new($X + 1, $Y + 1, [int][string]($inputData[$X][$Y]))
            $points.add([string]$point, $point)
        }
    }

    function print-points {
        foreach ($X in 1..10) {
            $row = foreach ($Y in 1..10) {
                [string]$point = '' + $X + ',' + $Y
                if ($points[$point].value -eq 0) {
                    $PSStyle.Foreground.Yellow 
                    $points[$point].value
                    $PSStyle.Reset
                }
                else {
                    $points[$point].value
                }
                
            }
            -join $row
        }
    }

    function BumpPoint ([string]$point) {
        $points[$point].value ++ 
        if ($points[$point].value -eq 10) {
            foreach ($neighbor in $points[$point].neighbors) {
                BumpPoint -point $points[$neighbor]
            }
        }
    }
    $FlashCount = 0
    $step = 0
    do {
        $step++
        foreach ($p in $points.GetEnumerator()) {
            BumpPoint -point $p.value
        }
        $Flashes = $points.GetEnumerator().Where{ $_.Value.Value -gt 9 }
        $FlashCount += $Flashes.Count
        $points.GetEnumerator().Where{ $_.Value.Value -gt 9 }.foreach{ $_.value.value = 0 }
        if($VerbosePreference) {
            ''
            "Step $step"
            print-points
            ''
        }
    } until ($Flashes.Count -eq 100)
    "Step $step"
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData -Verbose
'Part 2:'
Get-Part2 -inputData $inputData 

