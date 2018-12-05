$StartString = 'dabAcCaCBAcCcaDA'
$StartString = Get-Content $PSScriptRoot\5_input.txt

function React-polymer ($StartString)
{
    $TmpStrings = for ($i = 65; $i -le 90; $i++)
    {
        $CharLarge = [char]$i
        $CharSmall = [char]($i + 32)
        '{0}{1}' -f $CharLarge, $CharSmall
        '{1}{0}' -f $CharLarge, $CharSmall
    }

    $firstRun = $true
    do
    {
        if ($firstRun)
        {
            $firstRun = $false
            $ReplacedString = $StartString
        }
        else
        {
            $StartString = $ReplacedString
        }
        foreach ($TmpString in $TmpStrings)
        {
            $ReplacedString = $ReplacedString -creplace $TmpString, ''
        }
    } until ($ReplacedString.length -eq $StartString.length)
    $ReplacedString.Length
}


(65..90 | foreach {
        $TmpStartString = $StartString -replace [char]$_, ''
        React-polymer $TmpStartString
    } | Measure-Object -Minimum ).Minimum
