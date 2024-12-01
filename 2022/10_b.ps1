
class cycle {
    [int32]$cycle
    [int32]$value
    [int32]$line
    [int32]$lineStart
    [int32]$linePos
    [bool]$draw
    cycle([int32]$cycle,[int32]$value) {
        $this.cycle = $cycle
        $this.value = $value
        $this.line = [Math]::Ceiling($this.cycle/40)
        $this.lineStart = (($this.line - 1) * 40) + 1
        $this.linePos =   $this.cycle -  $this.lineStart 
        $this.draw = $this.linePos -in  ($this.value -1)..($this.value + 1)
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

#$result.ForEach{$_.draw ? '#' : '.'} -join ''
''
''
for ($i = 0; $i -lt $result.Count; $i+= 40) {
    $result[$i..($i+39)].ForEach{$_.draw ? '@' : ' '} -join ''
}
''
''

<#
@@@@ @  @   @@ @@@@ @@@    @@ @@@@ @@@@
   @ @ @     @ @    @  @    @ @       @
  @  @@      @ @@@  @@@     @ @@@    @
 @   @ @     @ @    @  @    @ @     @
@    @ @  @  @ @    @  @ @  @ @    @
@@@@ @  @  @@  @    @@@   @@  @    @@@@
#>