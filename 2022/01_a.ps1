$Input = (Get-Content -Path .\01.txt) -join ','
$input -split ',,' | ForEach-Object {
    ($_ -split ',' | Measure-Object -Sum).sum
} | Measure-Object -Maximum