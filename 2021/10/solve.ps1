function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    $result = 0
    $RegexPattern = '(\(\)|\{}|\[]|<>)'
    foreach ($string in $inputData) {
        
        $washedString = $string
        while ($washedString -match $RegexPattern) {
            $washedString = $washedString -replace $RegexPattern,''
        }
        if ($washedString -match '[\(\{<\[]([)>}\]])') {
            $illegal = $Matches[1]
            $result += switch ($illegal) {
                ')' { 3 }
                ']' { 57 }
                '}' { 1197 }
                '>' { 25137 }
                Default {}
            }
        }
    }
    $result
}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string[]]$inputData
    )
    $RegexPattern = '(\(\)|\{}|\[]|<>)'
    $results = foreach ($string in $inputData) {
        
        $washedString = $string
        while ($washedString -match $RegexPattern) {
            $washedString = $washedString -replace $RegexPattern,''
        }
        if ($washedString -notmatch '[\(\{<\[]([)>}\]])') {
            $tmpScore = 0
            $CharArray = [char[]]$washedString
            [array]::Reverse($CharArray)
            foreach ($char in $CharArray) {
                $Charvalue = switch ($char) {
                    '(' { 1 }
                    '[' { 2 }
                    '{' { 3 }
                    '<' { 4 }
                    Default {}
                }
                $tmpScore = ($tmpScore * 5) + $Charvalue
            }
            $tmpScore
        }
    }
    ($results | Sort-Object)[($results.count/2) - .5]
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData
