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

function Measure-Trees {
    param (
        $MoveRight,
        $MoveDown,
        $Slopes
    )

    $Horiz = 0
    $Vert = 0

    $width = $Slopes[0].Length
    $trees = 0

    do
    {
        $Horiz += $MoveRight
        $Vert += $MoveDown
        if ($Horiz -gt ($width - 1))
        {
            $Horiz = $Horiz - ($width)
        }
        if ($Slopes[$Vert][$Horiz] -eq '#')
        {
            $trees ++
        }
    } until ($Vert -eq ($Slopes.Length - 1))

    $trees
}

(Measure-Trees -MoveRight 1 -MoveDown 1 -slopes $Slopes)*
(Measure-Trees -MoveRight 3 -MoveDown 1 -slopes $Slopes)*
(Measure-Trees -MoveRight 5 -MoveDown 1 -slopes $Slopes)*
(Measure-Trees -MoveRight 7 -MoveDown 1 -slopes $Slopes)*
(Measure-Trees -MoveRight 1 -MoveDown 2 -slopes $Slopes)


