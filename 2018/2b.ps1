$Strings = 'abcde',
'fghij',
'klmno',
'pqrst',
'fguij',
'axcye',
'wvxyz'
$Strings = Get-Content $PSScriptRoot\2_input.txt

$StringHash = @{}
:outer_loop foreach ($String in $Strings)
{
    $CharArry = [char[]]$String
    for ($i = 0; $i -lt $String.length; $i++)
    {
        $tmpArray = $CharArry.Clone()
        $tmpArray[$i] = '*'
        $tmpString = $tmpArray -join ''
        if ($StringHash.ContainsKey($tmpString))
        {
            break outer_loop
        }
        else
        {
            $StringHash.Add($tmpString, $true)
        }
    }
}
$tmpString.Replace('*', '')