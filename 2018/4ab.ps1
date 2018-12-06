$Guardlogs = '[1518-11-01 00:00] Guard #10 begins shift',
'[1518-11-01 00:05] falls asleep',
'[1518-11-01 00:25] wakes up',
'[1518-11-01 00:30] falls asleep',
'[1518-11-01 00:55] wakes up',
'[1518-11-01 23:58] Guard #99 begins shift',
'[1518-11-02 00:40] falls asleep',
'[1518-11-02 00:50] wakes up',
'[1518-11-03 00:05] Guard #10 begins shift',
'[1518-11-03 00:24] falls asleep',
'[1518-11-03 00:29] wakes up',
'[1518-11-04 00:02] Guard #99 begins shift',
'[1518-11-04 00:36] falls asleep',
'[1518-11-04 00:46] wakes up',
'[1518-11-05 00:03] Guard #99 begins shift',
'[1518-11-05 00:45] falls asleep',
'[1518-11-05 00:55] wakes up'

$Guardlogs = Get-Content $PSScriptRoot\4_input.txt | Sort-Object

$GuardsList = @{}
$GuardsStats = @{}
$HourHash = @{}
0..59 | ForEach-Object {
    $HourHash.Add([int32]$_,0)
}

foreach ($Guardlog in $Guardlogs) {
    if ($Guardlog -match '\[(?<Date>\d+-\d+-\d+) \d+:(?<Minute>\d+)\] (?<LogEntery>Guard #(?<Guard>\d+) begins shift|(?<falls>falls) asleep|(?<wakes>wakes) up)') {
        if ($Matches['Guard']) {
            [int32]$Guard = $Matches['Guard']
            if (-not $GuardsList.ContainsKey($Guard)) {
                $GuardsList.Add($Guard,0) 
                $GuardsStats.Add($Guard,$HourHash.Clone())
            }
        }
        if ($Matches['falls']) {
            [int32]$StartSleep = $Matches['Minute']
        }
        if ($Matches['wakes']) {
            [int32]$EndSleep = $Matches['Minute']
             $StartSleep..($EndSleep - 1) |  ForEach-Object {
                 $GuardsStats[$Guard].$_ ++
                 $GuardsList[$Guard] ++
             }
        }
    }
}
$ChosenGuard = ($GuardsList.GetEnumerator() | Sort-Object -Property value -Descending)[0].name
$ChosenMinute = ($GuardsStats[$ChosenGuard].GetEnumerator()| Sort-Object -Property value -Descending)[0].name
$ChosenGuard * $ChosenMinute 


#Task B
$GuardsStats.GetEnumerator().ForEach{
    $TopMinute = ($_.value.GetEnumerator()| Sort-Object -Property value -Descending)[0]
    [PSCustomObject]@{
        Guard = $_.Name
        ChosenMinute = $TopMinute.name
        Value = $TopMinute.value
        Checksum = $_.Name * $TopMinute.name
    }
} | Sort-Object -Property value -Descending | Select-Object -First 1 -ExpandProperty Checksum