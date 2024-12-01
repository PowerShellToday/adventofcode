# The first column is what your opponent is going to play:
# A for Rock, B for Paper, and C for Scissors.

<#
ppreciative of your help yesterday, one Elf gives you an encrypted strategy guide (your puzzle input) that they say will be sure to help you win. "The first column is what your opponent is going to play: A for Rock, B for Paper, and C for Scissors. The second column--" Suddenly, the Elf is called away to help with someone's tent.

The second column, you reason, must be what you should play in response: X for Rock, Y for Paper, and Z for Scissors. Winning every time would be suspicious, so the responses must have been carefully chosen.

The winner of the whole tournament is the player with the highest score. Your total score is the sum of your scores for each round. The score for a single round is the score for the shape you selected (1 for Rock, 2 for Paper, and 3 for Scissors) plus the score for the outcome of the round (0 if you lost, 3 if the round was a draw, and 6 if you won).

Since you can't be sure if the Elf is trying to help you or trick you, you should calculate the score you would get if you were to follow the strategy guide.

For example, suppose you were given the following strategy guide:

A for Rock, B for Paper, and C for Scissors
X for Rock, Y for Paper, and Z for Scissors
0 if you lost, 3 if the round was a draw, and 6 if you won
1 for Rock, 2 for Paper, and 3 for Scissors

X means you need to lose, Y means you need to end the round in a draw, and Z means you need to win. Good luck!"
#>

$result = @{
    'A X' = (3 + 0)
    'A Y' = (1 + 3)
    'A Z' = (2 + 6)
    'B X' = (1 + 0)
    'B Y' = (2 + 3)
    'B Z' = (3 + 6)
    'C X' = (2 + 0)
    'C Y' = (3 + 3)
    'C Z' = (1 + 6)
}


Get-Content .\02.txt | Group-Object | Select-Object count, name | % {
    $_.count * $result[$_.name]
} | Measure-Object -Sum
