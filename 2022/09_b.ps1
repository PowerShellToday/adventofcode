class Head {

    [int]$x = 0
    [int]$y = 0
    [char]$direction

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

class Tail :head {
    
    [Hashtable]$History = @{'0,0'=1}

    [string]CatchUp([Head]$Head) {
        $res = ''
        $xDiff = $Head.x - $this.x 
        $yDiff = $Head.y - $this.y 
        $xDiffAbs = [math]::Abs($xDiff)
        $yDiffAbs = [math]::Abs($yDiff)
        $DiffAbsSum = $xDiffAbs + $yDiffAbs
        $StartPoint = '({0},{1})' -f $this.x, $this.y
        if ($DiffAbsSum -le 1) {
            # Same spot or next to, do nothing
            $res = '({0},{1}) Stay, Same spot or next to' -f $this.x, $this.y
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
            $res = '({0}) => ({1},{2}) Cath up, one direction' -f $StartPoint, $this.x, $this.y
        }
        else {
            # We are off by two on one or two axis
            
            foreach ($axis in ('x', 'y')) {
                if ($Head.$Axis -gt $this.$Axis) {
                    $this.$Axis ++
                }
                else {
                    $this.$Axis --
                }
            }
            $res = '({0}) => ({1},{2}) Cath up, two direction' -f $StartPoint, $this.x, $this.y
        }
        $pos = '{0},{1}' -f $this.x, $this.y
        $this.History[$pos]++
        return $this.Name + ' ' + $res
    }
}


$Rope = [ordered]@{
    0 = [Head]::new()
}
1..9 |% {
    $Rope.Add($_,[Tail]::new())
}
$Lines = Get-Content .\09_test2.txt
$Lines = Get-Content .\09.txt

foreach ($Line in $Lines) {
    [char]$Direction,[int32]$Count = $Line -split ' '
    foreach ($step in (1..$Count)) {
        $Rope[0].Move($Direction)
        1..9 |% {
            "$_  " + $Rope[$_].CatchUp($Rope[($_-1)])
        }
    }
}
$Rope[9].History.Keys.Count
