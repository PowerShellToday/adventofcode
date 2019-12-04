$RegexNumbers = foreach($number in 0..9){
    0..9 | ? {$_ -lt $number} | % {"$Number$_"}
}

$regex2 = '({0})' -f ($RegexNumbers -join '|')
# $regex2 = '(10|20|21|30|31|32|40|41|42|43|50|51|52|53|54|60|61|62|63|64|65|70|71|72|73|74|75|76|80|81|82|83|84|85|86|87|90|91|92|93|94|95|96|97|98)'

$pwds1 = 284639..748759 | where {$_ -match '(.)\1{1,}' -and $_ -notmatch $regex2}

$pwds1.Count

$pwds2 = $pwds1 -replace '((.)\2{2,})' , 'ab' | where {$_ -match '(.)\1{1,}' }
$pwds2.count

