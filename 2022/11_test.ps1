$a = @{}


'='
1..100 | % {
    $Number =$_ 
    $rest = ($number*19) % 23
    #<#
    [PSCustomObject]@{
        divideble = ([bool]-not($rest))
        Number = $Number
        rest = $rest
    }
    #>
    if([bool]-not($rest)){
        $a[$Number]++
    }
}


'='
1..100000 | % {
    $Number =$_ 
    $rest = ($number + 6) % 19
    <#
    [PSCustomObject]@{
        divideble = ([bool]-not($rest))
        Number = $Number
        rest = $rest
    }
    #>
    if([bool]-not($rest)){
        $a[$Number]++
    }
}


'='
1..100000 | % {
    $Number =$_ 
    $rest = ($number * $number) % 13
    <#
    [PSCustomObject]@{
        divideble = ([bool]-not($rest))
        Number = $Number
        rest = $rest
    }
    #>
    if([bool]-not($rest)){
        $a[$Number]++
    }
}


'='
1..100000 | % {
    $Number =$_ 
    $rest = ($number + 3) % 17
    <#
    [PSCustomObject]@{
        divideble = ([bool]-not($rest))
        Number = $Number
        rest = $rest
    }
    #>
    if([bool]-not($rest)){
        $a[$Number]++
    }
}


$a.GetEnumerator() |  where value -eq 4 | Sort-Object name