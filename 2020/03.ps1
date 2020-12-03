

$Slopes = '..##.......',
'#...#...#..',
'.#....#..#.',
'..#.#...#.#',
'.#...##..#.',
'..#.##.....',
'.#.#.#....#',
'.#........#',
'#.##...#...',
'#...##....#',
'.#..#...#.#'
$Slopes = Get-Content   "C:\test\lines.txt"
$Horiz = 0
$Vert = 0

$HorizMove = 3
$VertMove = 1
$width = $Slopes[0].Length
$trees = 0
''
do
{
    $Horiz += $HorizMove
    $Vert += $VertMove
    if ($Horiz -gt ($width - 1)) {
        $Horiz = $Horiz - ($width)
    }
    if ($Slopes[$Vert][$Horiz] -eq '#') {
        $trees ++
    }
} until ($Vert -eq ($Slopes.Length - 1))

$trees
