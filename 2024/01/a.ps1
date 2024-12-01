cd $psscriptroot

$a = @()
$b = @()

#Get-Content .\test.txt | foreach {
    Get-Content .\prod.txt | foreach {
        $a1,$b1 = $_ -split '   '
    $a += $a1
    $b += $b1
}

$a = $a | Sort-Object
$b = $b | Sort-Object

$tmp = for ($i = 0; $i -lt $a.Length; $i++) {
    # get the absolute value of the difference
    [math]::Abs([int]$a[$i] - [int]$b[$i])
}

$tmp | Measure-Object -Sum | Select-Object -ExpandProperty Sum