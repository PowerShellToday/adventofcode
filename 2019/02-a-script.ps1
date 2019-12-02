
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace 'script', 'functions'
. "$here\$sut"

$Inputs = Get-Content "$here\02-a-input.txt"
$Inarray = $Inputs -split ','
$Inarray[1] = 12
$Inarray[2] = 2
(restore-Intcode -optocode $Inarray)[0]


