class Stack {
    [System.Collections.ArrayList]$Pile = @()
    Stack() {
    }
    add([char]$crate) {
        $this.Pile.Add($crate)
    }
    [char]readTop() {
        return $this.Pile[-1]
    }
    [char]getTop() {
        $topBox = $this.Pile[-1]
        $this.Pile.RemoveAt($this.Pile.Count - 1)
        return $topBox 
    }
    [string[]]list() {
        return $this.Pile
    }
}
$InputFile = Get-Content .\05test.txt
#$InputFile = Get-Content .\05.txt
$Divider = $InputFile.IndexOf('')
$top = $InputFile[0..($Divider - 1)]
[array]::Reverse($top)
$stacks = [ordered]@{}
for ($x = 1; $x -lt $top[0].Length; $x += 4) {
    [string]$stack = $top[0][$x]
    $stacks.Add($stack, [Stack]::new())
    for ($y = 1; $y -lt $top.Count; $y++) {
        if (-not [string]::IsNullOrWhiteSpace($top[$y][$x]) ) {
            $stacks[$stack].add($top[$y][$x])
        }
    }
}
$instructions = $InputFile | Select-Object -Skip ($Divider + 1)
foreach ($instruction in $instructions) {
    $instruction -match '^move (\d+) from (\d) to (\d)' | Out-Null
    [int32]$Amount = $Matches[1]
    [string]$Source = $Matches[2]
    [string]$Target = $Matches[3]
    $TempPile = [Stack]::new()
    1..$Amount | ForEach-Object {
        $TempPile.add($stacks[$Source].getTop())
    }
    1..$Amount | ForEach-Object {
        $stacks[$Target].add($TempPile.getTop())
    }
}
($stacks.GetEnumerator().ForEach{ $_.value.getTop() }) -join ''