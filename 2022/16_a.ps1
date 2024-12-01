$lines = Get-Content .\16_test.txt
$lines = Get-Content .\16.txt

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


$valves = @{}
$valvesWithFlow = @{}

foreach ($line in $lines) {
    if ($line -match '^Valve (\w\w) has flow rate=(\d*); tunnels? leads? to valves? (.*)$' ) {
        $valve = [PSCustomObject]@{
            Name      = [string]$Matches[1]
            flowRate  = [int32]$Matches[2]
            next      = [string[]]($Matches[3].Replace(' ', '') -split ',')
            wayToHere = [string]''
        }
        $valves[$valve.name] = $valve
        if ($valve.flowRate) {
            $valvesWithFlow[$valve.name] = $valve.flowRate
        }
    }
    else {
        throw 'Not matching'
    }
}

$valvesWithFlow.keys.count


foreach ($startPoint in $valvesWithFlow.Keys + 'AA') {
    ' '
    foreach ($endpoint in $valvesWithFlow.Keys) {
        if ($startPoint -eq $endpoint) {
            continue
        }
        $vertexQueue = New-Object Queue
        # Do initial queue setup.
        #$startPoint = 'AA'
        $vertexQueue.enqueue($startPoint)
        #$endPoint = 'GG'
        $previousVertex = $null
        $history = @{}
    
        # Traverse all vertices from the queue.
        while (!$vertexQueue.isEmpty()) {
            $currentVertex = $valves[$vertexQueue.dequeue()]
            #$currentVertex.Visit($previousVertex.name)
            #enterVertex $currentVertex $previousVertex
        
            # Add all neighbors to the queue for future traversals.
            $currentVertex.next.ForEach{
                $Adjacent = $valves[$_] 
                if ( -not $history.ContainsKey($Adjacent.name)) {
                    $vertexQueue.enqueue($Adjacent.name)
                    $Adjacent.wayToHere = $currentVertex.name
                    $history[$Adjacent.name] = 1
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
        $point = $valves[$endPoint]
        do {
            $a ++
            $point = $valves[$point.wayToHere]
            #    $point.name
        } until (
            $point.name -ceq $startPoint
        )
        #$valves.Values
        "$startPoint => $endPoint $a"
        $valves.Keys.ForEach{ $valves[$_].wayToHere = '' }
    }
}