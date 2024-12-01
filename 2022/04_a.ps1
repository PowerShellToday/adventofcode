# ^(?<firstStart>\d+)-(?<firstEnd>\d+),(?<seccondStart>\d+)-(?<seccondEnd>\d+)$

# '2-4,6-8' -match '^(?<firstStart>\d+)-(?<firstEnd>\d+),(?<seccondStart>\d+)-(?<seccondEnd>\d+)$'

# '2-4,6-8' -match '^(\d+)-(\d+),(\d+)-(\d+)$'

$assignments = Get-Content .\04test.txt
$assignments = Get-Content .\04.txt
#$assignments
# high 659 607 
# 555
# low 434
#$result = 

$x = 0
$mresult = foreach ($assignment in $assignments) {
    if($assignment -match '^(\d+)-(\d+),(\d+)-(\d+)$') {
        
        ([int32]$Matches[1] -le [int32]$Matches[3] -and [int32]$Matches[2] -ge [int32]$Matches[4]) -or ([int32]$Matches[3] -le [int32]$Matches[1] -and [int32]$Matches[4] -ge [int32]$Matches[2])
    } else {
        Write-Error $assignment
    }
}

#$result 
$mresult.count
$mresult.Where{$_}.count