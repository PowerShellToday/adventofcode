class BingoBoard {
    [int32[, ]]$Numbers = (New-Object 'int[,]' 5, 5)
    [bool[, ]]$Called = (New-Object 'bool[,]' 5, 5)
    [bool]$isBingo = $false
    [int]$score
    [int]$turns = 0
    BingoBoard([string[]]$lines) {
        foreach ($row in (0..4)) {
            [int[]]$rowNumbers = $lines[$row].trim() -split '\s+'
            foreach ($col in (0..4)) {
                $this.Numbers[$row, $col] = $rowNumbers[$col]
            }
        }
    }

    Call([int]$CalledNumber) {
        $NumberOnBoard = $false
        $this.turns ++
        foreach ($row in (0..4)) {
            foreach ($col in (0..4)) {
                if ($this.Numbers[$row, $col] -eq $CalledNumber) {
                    $this.Called[$row, $col] = $true 
                    $NumberOnBoard = $true
                }
            }
        }
        if ($NumberOnBoard) {
            $this.CheckBingo()
            if ($this.isBingo) {
                $this.GetScore($CalledNumber)
            }
        }

    }

    GetScore([int]$CalledNumber) {
        [int]$score1 = 0
        foreach ($row in (0..4)) {
            foreach ($col in (0..4)) {
                if (-not $this.Called[$row,$col]) {
                    $score1 += $this.Numbers[$row,$col]
                }
            }
        }
        $this.score = $score1 * $CalledNumber
    }

    CheckBingo() {
        foreach ($row in (0..4)) {
            if ($this.Called[$row, 0] -and
                $this.Called[$row, 1] -and 
                $this.Called[$row, 2] -and 
                $this.Called[$row, 3] -and 
                $this.Called[$row, 4] 
            ) {
                $this.isBingo = $true            
            }
        }
        foreach ($col in (0..4)) {
            if ($this.Called[ 0, $col] -and
                $this.Called[ 1, $col] -and 
                $this.Called[ 2, $col] -and 
                $this.Called[ 3, $col] -and 
                $this.Called[ 4, $col] 
            ) {
                $this.isBingo = $true            
            }
        }
    }

    [string[]]PrintMe() {
        $result = foreach ($row in (0..4)) {
            foreach ($col in (0..4)) {
                $Style = $this.Called[$row, $col] ? "`e[7m" : "`e[0m"
                $Reset = "`e[0m"
                $Outstring = ([string]$this.Numbers[$row, $col]).PadLeft(3)
                "$Style$Outstring$Reset"
            }

            "`n"
        }
        $Result += if ($this.isBingo) {
            "    `e[7mBINGO!`e[0m"
        }
        Return  ($result -join "")
    }
}
function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Object[]]$inputData
    )
    
    begin {
        $Boards = for ($row = 2; $row -lt $inputData.Count; $row += 6) {
            [BingoBoard]::new($inputData[$row..($row + 4)])
        }

        $NumnersToCall = [int[]]($inputData[0] -split ',')
        :Checking foreach ($num in $NumnersToCall) {
            foreach ($Board in $Boards) {
                $Board.Call($num)
                
                if ($Board.isBingo) {
                    break Checking
                }
            }
        }
        '========================'
        $Board.PrintMe()
        $Board.score
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
        $Boards = for ($row = 2; $row -lt $inputData.Count; $row += 6) {
            [BingoBoard]::new($inputData[$row..($row + 4)])
        }

        $NumnersToCall = [int[]]($inputData[0] -split ',')
        :Checking foreach ($num in $NumnersToCall) {
            foreach ($Board in $Boards.where{-not $_.isBingo}) {
                $Board.Call($num)
                
               # if ($Board.isBingo) {
               #     break Checking
               # }
            }
        }
        '========================'
        $Board.PrintMe()
        $Board.score

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

