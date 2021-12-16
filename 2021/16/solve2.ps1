
function Parse-Data {
    [CmdletBinding()]
    param (
        [string]$string,
        [int]$start = 0,
        [int]$depth
    )
    $nextDepth = $depth + 1
    $result = [PSCustomObject]@{
        version  = [Convert]::ToInt32($string.Substring($start, 3), 2)
        typeID   = [Convert]::ToInt32($string.Substring($start + 3, 3), 2)
        string   = ''
        value    = 0
        depth    = $depth
        innerval = 0
    }
    Write-Verbose "==============================="
    Write-Verbose "String : $($string.substring($start))"
    Write-Verbose "Depth  : $depth"
    Write-Verbose "version: $($result.version)"
    Write-Verbose "typeID : $($result.typeID)"
    Write-Verbose "start  : $($start)"
    if ($result.typeID -eq 4) {
        $tmpStartPos = 6
        $tmpBits = do {
            $readbits = $string.Substring($tmpStartPos, 5)
            $readbits.substring(1, 4) 
            $tmpStartPos += 5
        } until ($readbits -match '^0')

        $result.string = $string.Substring(0, $tmpStartPos)
                
        $result.value = [Convert]::ToUInt64(($tmpBits -join ''), 2)
        Write-Verbose "value  :  $($result.value)"
    }
    else {
        $lengthTypeID = [Convert]::ToInt32($string.Substring($start + 6, 3), 2)
        $lengthTypeID = $string.Substring($start + 6, 1)
        $results = if ($lengthTypeID -eq 0) {
            $dataLength = [Convert]::ToInt32($string.Substring($start + 7, 15), 2)
            $Messages = $string.Substring($start + 22, $dataLength)
            $result.string = $string.Substring($start, $dataLength + 22)
            $startIndex = 0
            do {
                $tmp = @(Parse-Data -str $Messages.Substring($startIndex) -depth $nextDepth)
                $tmp
                $startIndex += $tmp[$tmp.GetUpperBound(0)].string.length
            } until ($startIndex -ge $Messages.Length)
        }
        else {
            $subpackets = [Convert]::ToInt32($string.Substring($start + 7, 11), 2)
            Write-Verbose "Sub Count : $subpackets"
            $startIndex = $start
            foreach ($packet in 1..$subpackets) {
                $tmp = @(Parse-Data -str $string.Substring(18 + $startIndex) -depth $nextDepth )
                $tmp
                $startIndex += $tmp[$tmp.GetUpperBound(0)].string.length
            }
            $result.string = $string.Substring($start, 18 + $startIndex)
        }
        $result.value = switch ($result.typeID) {
            0 { ($results | Measure-Object -Sum -Property value).sum }
            1 { 
                $tmpresult = 1
                foreach ($item in $results) {
                    $tmpresult = $tmpresult * $item.value
                }
                $tmpresult
            }
            2 { ($results | Measure-Object -Minimum -Property value).Minimum }
            3 { ($results | Measure-Object -Maximum -Property value).Maximum }
            5 { [int]($results[0].value -gt $results[1].value) }
            6 { [int]($results[0].value -lt $results[1].value) }
            7 { [int]($results[0].value -eq $results[1].value) }
            Default { }
        }
    }

    if ($depth -eq 0 -and $result.string.length % 8) {
        $pad = 0
        do {
            $pad++
    
        } while (($result.string.length + $pad) % 8)
        $result.string = $string.Substring(0, $result.string.length + $pad)
    }
    $result
}

$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt -Raw
$String = $inputData.ToCharArray().ForEach{ [uint32]"0x$_" }.foreach{ [System.Convert]::ToString($_, 2).padleft(4, '0') } -join ''

$res = Parse-Data -string $String -start 0 -depth 0 -verbose #| Format-Table | Out-Host
$res.value
