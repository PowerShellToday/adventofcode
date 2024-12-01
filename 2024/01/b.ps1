cd $psscriptroot

$a = @()
$b = @()

#Get-Content .\test.txt | foreach {
   Get-Content .\prod.txt | foreach {
        $a1,$b1 = $_ -split '   '
    $a += $a1
    $b += $b1
}

$b2 = $b | Group-Object -InputObject {"-$_-"} -AsHashTable

$results = $a | foreach {
    [int]$_ * $b2["-$_-"].Count
}

$results | Measure-Object -Sum