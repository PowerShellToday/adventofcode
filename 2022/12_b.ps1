
$InputFile = Get-Content .\12_test.txt
$InputFile = Get-Content .\12.txt

class Point {
    [int32]$x
    [int32]$y
    [bool]$visited = $false
    [string]$fromPoint
    [string]$name
    [string]$text
    [int32]$value
    hidden [Hashtable]$Adjacent = @{}
    
    point([int32]$x, [int32]$y, [string]$text, [int32]$value) {
        $this.x = $x
        $this.y = $y
        
        @(1, -1) | ForEach-Object {
            $tempY = $this.y + $_
            $tempX = $this.X + $_
            $this.Adjacent.Add("$tempX,$y", $null)
            $this.Adjacent.Add("$x,$tempY", $null)
            $this.name = ('{0},{1}' -f $this.x, $this.y)
            $this.text = $text
            $this.value = $value
            
        }
    }
    [string]ToString() {
        return $this.name
    }

    [string[]]GetAdjacent() {
        return $this.Adjacent.Keys
    }

    Visit([string]$from) {
        $this.visited = $true
        $this.fromPoint = $from
    }

    ClearVisit() {
        $this.visited = $false
        $this.fromPoint = ''
    }
}


class Queue {
    [System.Collections.ArrayList]$Items = @()

    [bool] isEmpty() {
        return !$this.Items.count
    }

    enqueue($value) {
        $this.Items.add($value)
    }

    [object] dequeue() {
        $CurrentItem = $this.Items[0]
        $this.Items.RemoveAt(0)
        return $CurrentItem 
    }

    [object[]] listqueue() {
        return $this.Items
    }

}



$points = @{}

[array]::Reverse($InputFile)

$y = 0
foreach ($Line in $InputFile) {
    $y++
    $x = 0
    foreach ($char in [char[]]$Line) {
        $x++


        $NewPoint = if ($char -ceq 'S') {
            #  S
            $startVertex = "$x,$y"
            [point]::new($x, $y, 'S', [int32][char]'a')
        }
        elseif ($char -ceq 'E') {
            #  E
            $endPoint = "$x,$y"
            [point]::new($x, $y, 'E', [int32][char]'z')
        }
        else {
            [point]::new($x, $y, $char, [char]$Char)
        }
        $points.Add("$x,$y", $NewPoint)
    }
}


$startpoints = $points.Keys.ForEach{ $points[$_] }.Where{ $_.text -ceq 'a' -or $_.text -ceq 'S' }.name

$results = foreach ($startVertex in $startpoints) {
    <# $currentItemName is the current item #>

    $points.Keys.ForEach{ $points[$_].ClearVisit() }
    $vertexQueue = New-Object Queue
    # Do initial queue setup.
    $vertexQueue.enqueue($startVertex)
    $previousVertex = $null
    $points[$startVertex].Visit('-')
    # Traverse all vertices from the queue.
    while (!$vertexQueue.isEmpty()) {
        $currentVertex = $points[$vertexQueue.dequeue()]

        # Add all neighbors to the queue for future traversals.
        $currentVertex.GetAdjacent().Where{ $points.Containskey($_) }.ForEach{
            $Adjacent = $points[$_] 
            if ((-not $Adjacent.visited) -and ($Adjacent.value -le ($currentVertex.value + 1)) ) {
                $vertexQueue.enqueue($Adjacent.name)
                $points[$Adjacent.name].Visit($currentVertex.name)
                if ($Adjacent.name -eq $endPoint) {
                    break
                }
            }
        }
        #leaveVertex $currentVertex $previousVertex
        # Memorize current vertex before next loop.
        $previousVertex = $currentVertex
    }


    $a = 0
    if ($points[$endPoint].visited) {
        <# Action to perform if the condition is true #>

        $point = $points[$endPoint]
        do {
            $a ++
            $point = $points[$point.fromPoint]
            # $point.name
        } until (
            $point.name -ceq $startVertex
        )
        $a
        $a | Write-Information 
    }
}

$results | Measure-Object -Minimum