class point {
    [int]$X
    [int]$Y
    point([int]$X, [int]$Y) {
        $this.X = $X
        $this.Y = $Y
    }
    [point[]]neighbors($maxX, $maxY) {
        $Return = @()
        if ($this.X -lt $maxX) {
            $return += [point]::new($this.X + 1, $this.Y)
        }
        if ($this.X -gt 0) {
            $return += [point]::new($this.X - 1, $this.Y)
        }
        if ($this.Y -lt $maxY) {
            $return += [point]::new($this.X, $this.Y + 1)
        }
        if ($this.Y -gt 0) {
            $return += [point]::new($this.X, $this.Y - 1)
        }
        return [point[]]$return
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
    
    $gridMap = foreach ($string in $inputData) {
        , [int[]][string[]][char[]]$string
        
    }
    $xmax = $gridMap.Length - 1 
    $ymax = $gridMap[0].Length - 1
    $Answer = 0
    foreach ($x in 0..$xmax) {
        foreach ($y in 0..$ymax) {
            $Value = $gridMap[$x][$y]
            $up = $x -eq 0 ? $Value + 1 : $gridMap[$x - 1][$y]
            if ($up -le $Value ) {
                Continue
            }
            $down = $x -eq $xmax ? $Value + 1 : $gridMap[$x + 1][$y]
            if ($down -le $Value ) {
                Continue
            }
            $left = $y -eq 0 ? $Value + 1 : $gridMap[$x][$y - 1]
            if ($left -le $Value ) {
                Continue
            }
            $right = $y -eq $ymax ? $Value + 1 : $gridMap[$x][$y + 1]
            if ($right -le $Value ) {
                Continue
            }
            $Answer += $Value + 1
        }
    }
    $Answer

}

function Get-Part2 {
    [CmdletBinding()]
    
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    
    $gridMap = foreach ($string in $inputData) {
        , [string[]][char[]]$string
    }
            
    $xmax = $gridMap.Length - 1 
    $ymax = $gridMap[0].Length - 1
    $result = @{}
    $Checked = @{}

    function set-point ([point]$Point, $basin) {
        $cValue = $gridMap[$Point.X][$Point.Y]
        $Checked[$Point.ToString()] = 1
        if ($cValue -match '^[0-8]$' ) {
            $result[$basin]++
            foreach ($neighbor in $Point.neighbors($xmax, $ymax)) {
                if (-not $Checked.ContainsKey($neighbor.ToString())) {
                    set-point -point $neighbor -basin $basin
                }
            }
        }
    }
    foreach ($x in 0..$xmax) {
        foreach ($y in 0..$ymax) {
            $cPoint = [point]::new($x, $y)
            if (-not $Checked.ContainsKey($cPoint.ToString())) {
                $cValue = $gridMap[$x][$y]
                $Checked[$cPoint.ToString()] = 1
                if ($cValue -match '^[0-8]$' ) {
                    set-point -point $cPoint -basin $cPoint.ToString()
                }
            }
        }
    }

    $v1, $v2, $v3 = ($result.GetEnumerator() | Sort-Object -Property Value -Descending -Top 3).value
    $v1 * $v2 * $v3
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData

