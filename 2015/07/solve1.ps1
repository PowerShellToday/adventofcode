

$data = 'test'
$data = 'prod'
$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
$inputData | Where-Object {$_ -Match '^\d'}
$inputData | Where-Object {$_ -Match 'LSHIFT'}