function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
    }
    
    end {
    }
}

function Get-Part2 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
    }
    
    end {
    }
}


$data = 'test'
$data = 'prod'

$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData

$string = 'abcdef'
$x = 609040
$x = 600040
$range = 609040..609090
#$range = 1..609090


$range | ForEach-Object  -Parallel {
    $string = 'abcdef'
    $test = $string + $_
    $stringAsStream = [System.IO.MemoryStream]::new()
    $writer = [System.IO.StreamWriter]::new($stringAsStream)
    $writer.write($test)
    $test
    $writer.Flush()
    $stringAsStream.Position = 0
    $Hash = (Get-FileHash -InputStream $stringAsStream -Algorithm MD5).Hash
    if ($Hash -match '^00000') {
        $_
        break
    }
}

break
$x = 1
$string = 'yzbqklnj'
do {
    $x++
    $test = $string + $x
    $stringAsStream = [System.IO.MemoryStream]::new()
    $writer = [System.IO.StreamWriter]::new($stringAsStream)
    $writer.write($test)
    $writer.Flush()
    $stringAsStream.Position = 0
    $Hash = (Get-FileHash -InputStream $stringAsStream -Algorithm MD5).Hash
    #$Hash 
} until ($Hash -match '^000000')
$x

$stringAsStream = [System.IO.MemoryStream]::new()
$writer = [System.IO.StreamWriter]::new($stringAsStream)
$writer.write("abcdef609043")
$writer.Flush()
$stringAsStream.Position = 0
Get-FileHash -InputStream $stringAsStream -Algorithm MD5 | Select-Object Hash
