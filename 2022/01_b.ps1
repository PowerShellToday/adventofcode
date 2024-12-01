$Input = (Get-Content -Path .\01.txt) -join ','
$input -split ',,' | ForEach-Object {
    ($_ -split ',' | Measure-Object -Sum).sum
} |Sort-Object -Descending| Select-Object -First 3| Measure-Object -Sum