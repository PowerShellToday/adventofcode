function Get-Boardingpass {
    param (
        $Boardingpass
    )
    $row = [Convert]::ToInt32($Boardingpass.Substring(0, 7).Replace('F', '0').Replace('B', '1'), 2)
    $Seat = [Convert]::ToInt32($Boardingpass.Substring(7).Replace('L', '0').Replace('R', '1'), 2)
    [PSCustomObject][ordered]@{
        Input = $Boardingpass
        Row   = $row 
        Seat  = $Seat
        ID    = ($row * 8 ) + $Seat
    }
    
}


$Tests = 'FBFBBFFRLR',
'BFFFBBFRRR',
'FFFBBBFRRR',
'BBFFBBFRLL'
$tests = Get-Content ./input.txt
$results = foreach ($test in $Tests) {
    Get-Boardingpass -Boardingpass $test
}

#Part A
($results | Measure-Object -Property id -Maximum).Maximum

#Part B
$IDRange = $results.id | Measure-Object -Maximum -Minimum
$hashtable = $results | Group-Object -Property id -AsHashTable
(($IDRange.Minimum)..($IDRange.Maximum)).Where{ 
    (
        -not $hashtable.ContainsKey($_)
    ) -and
    $hashtable.ContainsKey($_ + 1) -and
    $hashtable.ContainsKey($_ - 1)
}
