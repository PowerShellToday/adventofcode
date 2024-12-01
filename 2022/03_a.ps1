

$Rucksacks = Get-Content .\03.txt 

$RuckSackData = foreach ($Rucksack in $Rucksacks) {
    $size = $Rucksack.Length
    $compartment1 = $Rucksack.Substring(0,($size/2))
    $compartment2 = $Rucksack.Substring(($size/2))
    $item = Compare-Object -ReferenceObject ([char[]]$compartment1) -DifferenceObject ([char[]]$compartment2) -IncludeEqual -ExcludeDifferent -CaseSensitive | Select-Object -ExpandProperty InputObject -First 1
    [PSCustomObject]@{
        item = $item
        itemValue = ([int]$item -ge 65 -and [int]$item -le 90 ? [int]$item-38:[int]$item-96) 
        charValue = [int]$item
    }
} 

$RuckSackData | Measure-Object -Sum -Property itemValue