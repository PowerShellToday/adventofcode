class Head {
    [int]$x = 0
    [int]$y = 0
    [char]$direction
    Head() {
    }
    Move([char]$direction) {
        $this.direction = ([string]$direction).ToUpper()
        switch ($direction) {
            'U' {
                $this.y ++
            }
            'D' {
                $this.y --
            }
            'R' {
                $this.x ++
            }
            'L' {
                $this.x --
            }
            Default {}
        }
    }
}


class Tail {
    [int]$x = 0
    [int]$y = 0
    [Hashtable]$History = @{'0,0'=1}
    Tail() {
    }
    [string]CatchUp([Head]$Head) {
        $res = ''
        $xDiff = $Head.x - $this.x 
        $yDiff = $Head.y - $this.y 
        $xDiffAbs = [math]::Abs($xDiff)
        $yDiffAbs = [math]::Abs($yDiff)
        $DiffAbsSum = $xDiffAbs + $yDiffAbs
        if ($DiffAbsSum -le 1) {
            $res = '({0},{1}) Stay, Same spot or next to' -f $this.x, $this.y
            # Same spot or next to, do nothing
        }
        elseif ($xDiffAbs -eq 1 -and $yDiffAbs -eq 1 ) {
            # We are corner to corner
            $res = '({0},{1}) Stay, Corner to Corner' -f $this.x, $this.y
        }        
        elseif ($xDiffAbs -xor $yDiffAbs) {
            # We are on same line only one axis differ
            $Axis = [bool]$xDiffAbs ? 'x':'y'
            if ($Head.$Axis -gt $this.$Axis) {
                $this.$Axis ++
            }
            else {
                $this.$Axis --
            }
            $res = '({0},{1}) Cath up, one direction' -f $this.x, $this.y
        }
        else {
            foreach ($axis in ('x', 'y')) {
                if ($Head.$Axis -gt $this.$Axis) {
                    $this.$Axis ++
                }
                else {
                    $this.$Axis --
                }
            }
            $res = '({0},{1}) Cath up, one direction' -f $this.x, $this.y
        }
        $pos = '{0},{1}' -f $this.x, $this.y
        $this.History[$pos]++
        return $res
    }
}

$head = [Head]::new()
$tail = [Tail]::new()


$Lines = Get-Content .\09_test.txt
$Lines = Get-Content .\09.txt

$numbers = foreach ($Line in $Lines) {
    [char]$Direction,[int32]$Count = $Line -split ' '
    foreach ($step in (1..$Count)) {
        $head.Move($Direction)
        $tail.CatchUp($head)
    }
}
$tail.History.Keys.Count
