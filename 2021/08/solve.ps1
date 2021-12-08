function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    $words = foreach ($string in $inputData) {
        ($string -split '\|')[1].trim() -split ' ' | Where-Object { $_.length -in @(2, 3, 4, 7) }
    }
    $words.count

}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    
    $result = 0
    foreach ($string in $inputData) {
        $inputData = ($string -split '\|')[0].trim() -split ' '
        $ParsedNumbers = get-stringdata -input $inputData 
        $Number1 = $ParsedNumbers.Where{$_.intVaule -eq 1}
        #$Number4 = $ParsedNumbers.Where{$_.intVaule -eq 4}
        #$Number7 = $ParsedNumbers.Where{$_.intVaule -eq 7}
        #$Number8 = $ParsedNumbers.Where{$_.intVaule -eq 8}
        $Number3 = $ParsedNumbers.Where{$_.StringLength -eq 5} | Where-Object {($_.binaryValue -band $Number1.binaryValue) -eq $Number1.binaryValue}
        $ParsedNumbers[$Number3.index].intVaule = 3
        $Number6 = $ParsedNumbers.Where{$_.StringLength -eq 6} | Where-Object {($_.binaryValue -band $Number1.binaryValue) -ne $Number1.binaryValue}
        $ParsedNumbers[$Number6.index].intVaule = 6
        $Number9 = $ParsedNumbers.Where{$_.StringLength -eq 6} | Where-Object {($_.binaryValue -band $Number3.binaryValue) -eq $Number3.binaryValue}
        $ParsedNumbers[$Number9.index].intVaule = 9
        $Number0 = $ParsedNumbers.Where{$_.StringLength -eq 6 -and [string]::IsNullOrEmpty($_.intVaule)}
        $ParsedNumbers[$Number0.index].intVaule = 0
        $Number5 = $ParsedNumbers.Where{$_.StringLength -eq 5} | Where-Object {($_.binaryValue -band $Number6.binaryValue) -eq $_.binaryValue}
        $ParsedNumbers[$Number5.index].intVaule = 5
        $Number0 = $ParsedNumbers.Where{$_.StringLength -eq 5 -and [string]::IsNullOrEmpty($_.intVaule)}
        $ParsedNumbers[$Number0.index].intVaule = 2
        

        $Translator = @{}
        foreach ($ParsedNumber in $ParsedNumbers) {
            $Translator[$ParsedNumber.binaryValue] = $ParsedNumber.intVaule
        }

        $outputData = ($string -split '\|')[1].trim() -split ' '
        $ParsedOutput = (get-stringdata -input $outputData).binaryValue
        [int]$tmpresult = -join $ParsedOutput.foreach{$Translator[$_]}
        $result += $tmpresult
    }
    $result
}

function get-stringdata {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    $index = 0
    foreach ($string in $inputData) {
        $boolrray = foreach ($char in [char[]]'abcdefg') {
            $string -match $char
        }

        $intVaule = if ($string.Length -eq 7) {
            8
        } elseif ($string.Length -eq 2) {
            1
        } elseif ($string.Length -eq 3) {
            7
        } elseif ($string.Length -eq 4) {
            4
        } else {
                 ''   }

        $tmp = [PSCustomObject]@{
            StringLength = $string.Length
            intVaule     = $intVaule
            binaryValue  = [Convert]::ToInt32( -join [int[]]$boolrray, 2)
            index = $index
        }
        $index ++
        $tmp  
    }
    
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData
