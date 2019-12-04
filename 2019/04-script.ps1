$RegexNumbers = foreach($number in 0..9){
    0..9 | ? {$_ -lt $number} | % {"$Number$_"}
}

$regex2 = '({0})' -f ($RegexNumbers -join '|')

284639..748759 | where {$_ -match '(.)\1{1,}' -and $_ -notmatch $regex2} |Measure-Object
