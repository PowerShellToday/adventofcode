
class cycle {
    [int32]$cycle
    [int32]$value
    [int32]$signalStrength
    cycle([int32]$cycle,[int32]$value) {
        $this.cycle = $cycle
        $this.value = $value
        $this.signalStrength = $cycle * $value
    }
}


$commands =  'noop','addx 3','addx -5'
$commands = Get-Content .\10_test.txt
$commands = Get-Content .\10.txt
$x = 1
$cycle = 1
$result = foreach ($line in $commands) {
    if ($line -eq 'noop') {
        [cycle]::new($cycle,$x)
        $cycle ++
    } else {
        $null, [int32]$v = $line -split ' '
        [cycle]::new($cycle,$x)
        $cycle ++
        [cycle]::new($cycle,$x)
        $cycle ++
        $x += $v
    }
}

$Targets = 20, 60, 100, 140, 180, 220
$result | Where-Object {$_.cycle -in $Targets} | Measure-Object -Property signalStrength -Sum
