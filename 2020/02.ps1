
$lines = Get-Content "C:\test\lines.txt"
#$lines = '1-3 a: abcde', '1-3 b: cdefg', '2-9 c: ccccccccc'

$ok = 0
foreach ($line in $lines)
{
    $line -match "^(?'min'\d*)-(?'max'\d*) (?'char'[a-z]): (?'string'[a-z]*)$" | Out-Null
    if ($Matches.string[$Matches.min - 1] -eq $Matches.char -xor $Matches.string[$Matches.max - 1] -eq $Matches.char)
    {
        $ok ++
    }
}
$ok




break
$ok = 0
foreach ($line in $lines)
{
    $line -match "^(?'min'\d*)-(?'max'\d*) (?'char'[a-z]): (?'string'[a-z]*)$" | Out-Null
    $Ocurnces = $Matches.string.Length - $Matches.string.Replace($Matches.char, '').Length
    if ($Ocurnces -ge $Matches.min -and $Ocurnces -le $Matches.max)
    {
        $ok ++
    }
}
$ok
