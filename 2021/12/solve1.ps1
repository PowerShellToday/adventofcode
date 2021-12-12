
$data = 'test1'
$data = 'test2'
$data = 'test3'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt


$VerbosePreference = 'Continue'
$Connections = @{}
foreach ($line in $inputData) {
    $a,$b = $line -split '-'
    if(-not $Connections.ContainsKey($a)) {
        $Connections[$a]= @()
    }
    if(-not $Connections.ContainsKey($b)) {
        $Connections[$b]= @()
    }
    $Connections[$a]+= $b
    $Connections[$b]+= $a
}

function get-out {
    param (
        [string[]]$PrevPath,
        [string]$cave
    )
    if ($PrevPath.Length -gt 15) {
        #return
    }
    $CurrentPath = $PrevPath + $cave
    if ($cave -ceq 'end') {
        $CurrentPath -join ','
        return
    }
    foreach ($out in $Connections[$cave]) {
        $SmallCave= $out -cmatch '^[a-z]*$'
        if($out -cmatch '^[a-z]*$' -and $out -cin $PrevPath) {
            Write-Verbose "$out is a small cave allready visited exit"
        } else {
            get-out -PrevPath $CurrentPath -cave $out
        }
    }
    

}
$VerbosePreference = 'SilentlyContinue'

$paths = get-out -cave 'start' 
$paths.count