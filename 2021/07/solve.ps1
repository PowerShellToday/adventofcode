function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$inputData
    )
    
    $EndValues = $inputData | Measure-Object -Maximum -Minimum

    $calculations = for ($i = $EndValues.Minimum; $i -lt $EndValues.Maximum; $i++) {
        $tmpresult = foreach ($pos in $inputData) {
            [math]::Abs($pos - $i)
        }
        
        [PSCustomObject]@{
            'Pos'  = $i
            'Fuel' = ($tmpresult | Measure-Object -Sum).Sum
        }
    }
    $calculations | Sort-Object -Property 'Fuel' -Descending | Select-Object -Last 1

}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int[]]$inputData
    )
    
    $EndValues = $inputData | Measure-Object -Maximum -Minimum
    #$EndValues.Maximum | Write-Debug
    #$EndValues.Minimum | Write-Debug
    
    $lookup = @{}
    $EndValues.Minimum..$EndValues.Maximum | % {
        $lookup.Add($_,(0..$_| Measure-Object -Sum).Sum)
    }

    $calculations = for ($i = $EndValues.Minimum; $i -lt $EndValues.Maximum; $i++) {
        $tmpresult =  foreach ($pos in $inputData) {
            $length = [math]::Abs($pos - $i)
            $lookup.[int]$length
        }
        
        $tmp = [PSCustomObject]@{
            'Pos'  = $i
            'Fuel' = ($tmpresult | Measure-Object -Sum).Sum
        }
        $tmp | Write-Debug
        $tmp
    }
    $calculations | Sort-Object -Property 'Fuel' -Descending | Select-Object -Last 1
}


$data = 'test'
$data = 'prod'

[int[]]$inputData = (Get-Content -Path $PSScriptRoot/input_$data.txt) -split ','
'Part 1:'
#Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData -Debug

