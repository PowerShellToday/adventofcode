
$InputData = Get-Content .\2020\6_test.txt -Raw
$InputData = Get-Content .\2020\6_data.txt -Raw
$InputData = $InputData.Replace("`r`n" , "`n")

$Answers = foreach ($group in $InputData.Split("`n`n")) {
    ([char[]]$group.Replace("`n", '') | Sort-Object | Select-Object -Unique).count
}

($Answers | Measure-Object -Sum).sum

#(Get-Content .\6\data.txt).where{ $_ }.count