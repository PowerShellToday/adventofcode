$inputs = 'mjqjpqmgbljsphdztnvjfqwrcgsmlb', # 7
'bvwbjplbgvbhsrlpgdmjqwftvncz', #: first marker after character 5
'nppdvjthqldpwncqszvftbrmjlhg', #: first marker after character 6
'nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg', #: first marker after character 10
'zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw'#: first marker after character 11

foreach ($inputString in $inputs) {
    $x = 0
    do {
        $string = $inputString.Substring($x, 4)
        $x++
    } until (
        $string -match '^(?:([A-Za-z])(?!.*\1))*$'
        <# C$stringondition that stops the loop if it returns true #>
    )
    $x + 3
}

$inputString = Get-Content .\06.txt
$x = 0
do {
    $string = $inputString.Substring($x, 4)
    $x++
} until (
    $string -match '^(?:([A-Za-z])(?!.*\1))*$'
)
$x + 3