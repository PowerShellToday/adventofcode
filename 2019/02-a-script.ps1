
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace 'script', 'functions'
. "$here\$sut"

$Inputs = Get-Content "$here\02-a-input.txt"
$Inarray = $Inputs -split ','
$Inarray[1] = 12
$Inarray[2] = 2
"Answer A:"
(restore-Intcode -optocode $Inarray)[0]

"Answer B:"
for ($noun = 0; $noun -lt 100; $noun++) {
    for ($verb = 0; $verb -lt 100; $verb++) {
        $Inarray = $Inputs -split ','
        $Inarray[1] = $noun
        $Inarray[2] = $verb
        $result = (restore-Intcode -optocode $Inarray)[0]
        if ($result -eq 19690720) {
            100 * $noun + $verb
            $noun = $verb = 1000
        }
    }
}
