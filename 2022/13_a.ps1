
$InputFile = Get-Content .\13_test.txt
#$InputFile = Get-Content .\13.txt
# 6695 high
# Should be
#Part 1 = 5588
#Part 2 = 23958

$Rows = (($InputFile) -join ';') -split ';;'

$VerbosePreference = 'Continue'
function compare-Lists {
    param (
        $leftObj,
        $rightObj
    )
    '----' | Write-Verbose 
    ,$leftObj | ConvertTo-Json -Compress -Depth 99 | Write-Verbose 
    ,$rightObj | ConvertTo-Json -Compress -Depth 99 | Write-Verbose 
    '----' | Write-Verbose 
    '----' | Write-Verbose 
    if ('[[],[[7,9,4,1]],[],[[2],7,[5,9,5,1],10],8]' -eq ($leftObj | ConvertTo-Json -Compress -Depth 99)) {
        #''
    }

    #Start-Sleep -Seconds 1
    if (
        (-not [string]::IsNullOrEmpty($leftObj)) -and
        (-not [string]::IsNullOrEmpty($rightObj)) -and
        $leftObj.GetType().IsArray -and
        $rightObj.GetType().IsArray
    ) {
        $ItemCount = ($leftObj.Count, $rightObj.Count | Measure-Object -Maximum).Maximum
        for ($i = 0; $i -lt $ItemCount; $i++) {
            $result = compare-Lists $leftObj[$i] $rightObj[$i] 
            if ($result -match '(right|left)') {
                
                $result
                break
            }
        }
    }elseif ([string]::IsNullOrEmpty($rightObj) -xor [string]::IsNullOrEmpty($leftObj)) {
        if ([string]::IsNullOrEmpty($rightObj)) {
            'right'
        }
        elseif ([string]::IsNullOrEmpty($leftObj)) {
            'left'
        }
    }
    elseif (
        (
            [string]::IsNullOrEmpty($leftObj) -or
            $leftObj.GetType().IsValueType
        ) -xor 
        (
            [string]::IsNullOrEmpty($rightObj) -or
            $rightObj.GetType().IsValueType
        )
    ) {
        if (@($leftObj).count -eq 0) {
            'left'
        }
        elseif (@($rightObj).count -eq 0) {
            'right'
        }
        else {
            compare-Lists @($leftObj) @($rightObj)
        }
        
    }
    elseif (
        (
            [string]::IsNullOrEmpty($leftObj) -or
            $leftObj.GetType().IsValueType
        ) -and
        (
            [string]::IsNullOrEmpty($rightObj) -or
            $rightObj.GetType().IsValueType
        )
    ) {
        if ($leftObj -lt $rightObj) {
            'left'
        }
        elseif ($rightObj -lt $leftObj) {
            'right'
        }
        else {
            'eq'
        }
    }
    
}

$x = 0
# [[[[[9]]],[],[9,[8],8],[[7,[],4],8,[[],1,[0,4,7],[3,10,6]]]]]
#$results = foreach ($Row in $Rows[144]) {
        $results = foreach ($Row in $Rows) {
    $x++
    $x | write-host
    [string]$left, [string]$right = $Row -split ';'
    $leftObj = (, @($left | ConvertFrom-Json -Depth 99))
    $rightObj = (, @($right | ConvertFrom-Json -Depth 99))
    $Result = compare-Lists $leftObj $rightObj
    $result | Write-Verbose
    [PSCustomObject]@{
        Result = $Result
        Pair   = $x
    }
}
$results
''
$results | Where-Object Result -eq 'Left' | Measure-Object -Property pair -Sum