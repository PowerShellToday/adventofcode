<#
For example, if you see the following box IDs:
abcdef contains no letters that appear exactly two or three times.
bababc contains two a and three b, so it counts for both.
abbcde contains two b, but no letter appears exactly three times.
abcccd contains three c, but no letter appears exactly two times.
aabcdd contains two a and two d, but it only counts once.
abcdee contains two e.
ababab contains three a and three b, but it only counts once.

Of these box IDs, four of them contain a letter which appears exactly twice,
and three of them contain a letter which appears exactly three times.
Multiplying these together produces a checksum of 4 * 3 = 12.

#>

$List = 'abcdef',
'bababc',
'abbcde',
'abcccd',
'aabcdd',
'abcdee',
'ababab'
$List = Get-Content $PSScriptRoot\2_input.txt
$TopList = foreach ($item in $List)
{
    [char[]]$item | Group-Object | Where-Object Count -in 2, 3 |Select-Object -ExpandProperty count -Unique

}

$Stats = $TopList  | Group-Object | Select-Object -ExpandProperty Count

$Stats[0] * $Stats[1]