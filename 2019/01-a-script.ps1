$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace 'script', 'functions'
. "$here\$sut"

$Inputs = Get-Content "$here\01-a-input.txt"
Get-FuelCalc -Mass $Inputs
Get-TotalFuelCalc -Mass $Inputs