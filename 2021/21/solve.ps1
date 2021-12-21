
class player {
    [string]$Name
    [int]$score = 0
    [int]$boardpos
    [bool]$winner = $false
    player([string]$Name, [int]$startpos) {
        $this.Name = $Name
        $this.boardpos = $startpos
    }
    move([int]$d1, [int]$d2, [int]$d3) {
        $steps = $d1 + $d2 + $d3
        $steps = [int][string]$steps.ToString()[-1]
        $this.boardpos += $steps
        if ($this.boardpos -gt 10) {
            $this.boardpos -= 10
        }
        $this.score += $this.boardpos
        if ($this.score -ge 1000) {
            $this.winner = $true
        }
    }
}

class dice {
    [int[]]$numbers = 1..100
    [int32]$nextIndex = 0
    [int32]$rolled = 0
    [int]roll() {
        $returnValue = $this.numbers[$this.nextIndex]
        $this.nextIndex ++
        $this.rolled ++
        if ($this.nextIndex -eq 100) {
            $this.nextIndex = 0
        }
        return $returnValue
    }
    reset() {
        $this.nextIndex = 0
    }
}



function Get-Part1 {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [int]$p1,
        [Parameter(Mandatory = $true)]
        [int]$p2
    )
    
    $player1 = [player]::new('Player 1', $p1)
    $player2 = [player]::new('Player 2', $p2)

    $currentPlayer = $player1
    $nextPlayer = $player2
    $dice = [dice]::new()

    while ($true) {
        $d1 = $dice.roll()
        $d2 = $dice.roll()
        $d3 = $dice.roll()
        $currentPlayer.move($d1, $d2, $d3)
        if ($currentPlayer.winner ) {
            break
        }
        $currentPlayer, $nextPlayer = $nextPlayer, $currentPlayer
    }

    $LoosingScore = $player1.score, $player2.score | Sort-Object | Select-Object -First 1
    $LoosingScore * $dice.rolled

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
$inputData[0] -match '^Player \d starting position: (\d)'
$p1 = $Matches[1]

$inputData[1] -match '^Player \d starting position: (\d)'
$p2 = $Matches[1]


'Part 1:'
Get-Part1 -p1 $p1 -p2 $p2
'Part 2:'
#Get-Part2 -inputData $inputData

