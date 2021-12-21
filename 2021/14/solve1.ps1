
$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt

$StartString = $inputData[0]

$Instructions = $inputData[2..$inputData.GetUpperBound(0)]

$Transforms = @{}

foreach ($Instruction in $Instructions) {
    $pattern,$insert = $Instruction  -split ' -> '
    $Transforms[$pattern] = $pattern[0]+$insert.ToLower()+$pattern[1]
}

$InputString = $StartString
foreach ($step in 1..10) {
    foreach ($replace in $Transforms.GetEnumerator()) {
        $InputString = $InputString -creplace $replace.name, $replace.value
        $InputString = $InputString -creplace $replace.name, $replace.value
        #$replace
    }
    $InputString = $InputString.ToUpper()
    "After step $($step): $($InputString.length)"
    #"After step $($step): $($InputString)"
}


$Summary = [char[]]$InputString | Group-Object | Measure-Object -Maximum -Minimum -Property count
$Summary.Maximum -$Summary.Minimum 
break
$InputString = $StartString
$InputString = $StartString
foreach ($step in 1..40) {
    foreach ($replace in $Transforms.GetEnumerator()) {
        $InputString = $InputString -creplace $replace.name, $replace.value
        #$replace
    }
    $InputString = $InputString.ToUpper()
    "After step $($step): $($InputString.length)"
}


$Summary = [char[]]$InputString | Group-Object | Measure-Object -Maximum -Minimum -Property count
$Summary.Maximum -$Summary.Minimum 

