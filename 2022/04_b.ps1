# ^(?<firstStart>\d+)-(?<firstEnd>\d+),(?<seccondStart>\d+)-(?<seccondEnd>\d+)$

# '2-4,6-8' -match '^(?<firstStart>\d+)-(?<firstEnd>\d+),(?<seccondStart>\d+)-(?<seccondEnd>\d+)$'

# '2-4,6-8' -match '^(\d+)-(\d+),(\d+)-(\d+)$'

$assignments = Get-Content .\04test.txt
$assignments = Get-Content .\04.txt


#$mresult =
 foreach ($assignment in $assignments) {
    if($assignment -match '^(\d+)-(\d+),(\d+)-(\d+)$') {
        $a1 = [int32]$Matches[1]
        $a2 = [int32]$Matches[2]
        $b1 = [int32]$Matches[3]
        $b2 = [int32]$Matches[4]
        #$assignment 
        ($a2 -ge $b1 -and $a1 -le $b2) 
        ($b2 -ge $a1 -and $b1 -le $a2)
        ""
    } else {
        Write-Error $assignment
    }
}

#$result 
$mresult.count
$mresult.Where{$_}.count