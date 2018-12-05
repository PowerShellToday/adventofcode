$Numbers = Get-Content $PSScriptRoot\1_input.txt

$SeenFreq = @{}

$Freq = 0
do
{
    foreach ($Number in $Numbers)
    {
        $Freq += $Number
        if ($SeenFreq.ContainsKey($Freq))
        {
            $Success = $true
            break
        }
        else
        {
            $SeenFreq.Add($Freq, $true)
            $Success = $false
        }
    }
} until ($Success)

$Freq