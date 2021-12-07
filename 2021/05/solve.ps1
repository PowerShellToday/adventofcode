class Vent {
    [int]$StartX
    [int]$StartY
    [int]$EndX
    [int]$EndY
    [bool]$isStraight
    [string]$Direction
    [string[]]$Cover
    Vent($Definition) {
        $this.StartX, $this.StartY, $this.EndX, $this.EndY = [int[]]($Definition.Replace(' -> ', ',') -split ',')

        if ($this.StartX -eq $this.EndX) {
            $this.isStraight = $true
            $this.Direction = 'Horizontal'
        }
        elseif ($this.StartY -eq $this.EndY) {
            $this.isStraight = $true
            $this.Direction = 'Vertical'
        }
        else {
            $this.isStraight = $false
            $this.Direction = 'Diagonal'
        }
        if ($this.Direction -eq 'Horizontal' ) {
            $this.Cover = $this.StartY..$this.EndY | % { "$($this.StartX),$_" }
        }
        if ($this.Direction -eq 'Vertical' ) {
            $this.Cover = $this.StartX..$this.EndX | % { "$_,$($this.StartY)" }
        }
        if ($this.Direction -eq 'Diagonal' ) {
            $ysteps = $this.StartY..$this.EndY
            $xsteps = $this.StartX..$this.EndX
            $this.Cover = for ($i = 0; $i -lt $xsteps.count; $i++) {
                '{0},{1}' -f $xsteps[$i], $ysteps[$i]
            }
        }
    }
}


#[Vent]::new('0,0 -> 3,3')
#[Vent]::new('3,3 -> 0,0')
#[Vent]::new('3,0 -> 0,3')
#
#break
#[Vent]::new('5,7 -> 5,9')
#[Vent]::new('0,9 -> 5,9')
#[Vent]::new('8,0 -> 0,8')

function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
    }
    
    process {
        $tmpResult = foreach ($item in $inputData) {
            [Vent]::new($item)
        }
        $tmpResult = $tmpResult | Where-Object { $_.isStraight } 
        ($tmpResult.Cover | Group-Object | Where-Object Count -gt 1).Count
        
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
        $tmpResult = foreach ($item in $inputData) {
            [Vent]::new($item)
        }
        ($tmpResult.Cover | Group-Object | Where-Object Count -gt 1).Count
    }
    
    end {
    }
}


$data = 'test'
$data = 'prod'
#Get-Content -Path $PSScriptRoot/input_$data.txt
$inputData = Get-Content -Path $PSScriptRoot/input_$data.txt
'Part 1:'
Get-Part1 -inputData $inputData 
'Part 2:'
Get-Part2 -inputData $inputData

