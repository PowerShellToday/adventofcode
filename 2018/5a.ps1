<#
dabAcCaCBAcCcaDA  The first 'cC' is removed.
dabAaCBAcCcaDA    This creates 'Aa', which is removed.
dabCBAcCcaDA      Either 'cC' or 'Cc' are removed (the result is the same).
dabCBAcaDA        No further actions can be taken.


'dabAcCaCBAcCcaDA'
'dabAaCBAcCcaDA'
 dabAaCBAcaDA
'dabCBAcCcaDA'
'dabCBAcaDA'
 dabCBAcaDA
 dabCBAcaDA
#>

$StartString = 'dabAcCaCBAcCcaDA'
$StartString = Get-Content $PSScriptRoot\5_input.txt
#$StartString = -join $StartString[0..10000]

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
            $ReplacedString = $ReplacedString.Replace($TmpString, '')
        }
    } until ($ReplacedString.length -eq $StartString.length)
    $ReplacedString.Length
}
React-polymer -StartString $StartString