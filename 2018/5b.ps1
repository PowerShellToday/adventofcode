$StartString = 'dabAcCaCBAcCcaDA'
$StartString = Get-Content .\5_input.txt

function React-polymer ($StartString)
{
    $TmpStrings = for ($i = 65; $i -le 90; $i++)
    {
        $CharLarge = [char]$i
        $CharSmall = [char]($i + 32)
        '{0}{1}' -f $CharLarge, $CharSmall
        '{1}{0}' -f $CharLarge, $CharSmall
    }

    $regex = '({0})' -f ($TmpStrings -join '|')
    $x = 0
    do
    {
        $x ++
        if ($x -ne 1)
        {
            $StartString = $ReplacedString
        }

        $ReplacedString = $StartString -creplace $regex, ''
    } until ($ReplacedString.length -eq $StartString.length)
    $ReplacedString.Length
}


$chars = for ($i = 65; $i -le 90; $i++)
{
    [char]$i
}

$results = foreach ($char in $chars)
{
    $TmpStartString = $StartString -replace $char, ''
    React-polymer $TmpStartString
}

($results | Measure-Object -Minimum).Minimum
