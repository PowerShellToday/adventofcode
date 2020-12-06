
$InputData = Get-Content .\2020\6_test.txt -Raw
$InputData = Get-Content .\2020\6_data.txt -Raw
$InputData = $InputData.Replace("`r`n" , "`n")

$Answers = foreach ($group in $InputData.Split("`n`n")) {
    $Answers = $group.Split("`n").Count
    (([char[]]$group.Replace("`n", '')) | Group-Object | Where-Object count -eq $Answers | Measure-Object).Count

}

($Answers | Measure-Object -Sum).sum

