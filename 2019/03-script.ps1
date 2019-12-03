$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace 'script', 'functions'
. "$here\$sut"



$Inputs = Get-Content "$here\03-input.txt"
get-closestIntersection -wire1 $Inputs[0] -wire2 $Inputs[1]

get-closestIntersectionb -wire1 $Inputs[0] -wire2 $Inputs[1] -Verbose