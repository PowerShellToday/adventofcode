$Claimlines = '#1 @ 1,3: 4x4',
'#2 @ 3,1: 4x4',
'#3 @ 5,5: 2x2'
$Claimlines = Get-Content $PSScriptRoot\3_input.txt
$ClaimedSpoots = @{}

foreach ($Claimline in $Claimlines)
{
    if ($Claimline -match '#(?<ClaimID>\d+) @ (?<StartX>\d+),(?<StartY>\d+): (?<WidthX>\d+)x(?<HeightY>\d+)')
    {
        $claim = [PSCustomObject][ordered]@{
            ClaimID = [int32]$Matches['ClaimID']
            StartX = [int32]$Matches['StartX']
            StartY = [int32]$Matches['StartY']
            WidthX = [int32]$Matches['WidthX']
            HeightY = [int32]$Matches['HeightY']
        }
        $XList = ($claim.StartX + 1)..($claim.StartX + $claim.WidthX)
        $YList = ($claim.StartY + 1)..($claim.StartY + $claim.HeightY)

        foreach ($x in $XList)
        {
            foreach ($y in $YList)
            {
                $ClaimedSpoot = '{0}-{1}' -f $x, $y
                if ($ClaimedSpoots.ContainsKey($ClaimedSpoot))
                {
                    $ClaimedSpoots[$ClaimedSpoot] ++
                }
                else
                {
                    $ClaimedSpoots.add($ClaimedSpoot, 0)
                }
            }
        }
    }
}

#Answer A
$ClaimedSpoots.GetEnumerator().where{$_.value -ne 0}.count


foreach ($Claimline in $Claimlines)
{
    if ($Claimline -match '#(?<ClaimID>\d+) @ (?<StartX>\d+),(?<StartY>\d+): (?<WidthX>\d+)x(?<HeightY>\d+)')
    {
        $claim = [PSCustomObject][ordered]@{
            ClaimID = [int32]$Matches['ClaimID']
            StartX = [int32]$Matches['StartX']
            StartY = [int32]$Matches['StartY']
            WidthX = [int32]$Matches['WidthX']
            HeightY = [int32]$Matches['HeightY']
        }
        $XList = ($claim.StartX + 1)..($claim.StartX + $claim.WidthX)
        $YList = ($claim.StartY + 1)..($claim.StartY + $claim.HeightY)
        $Uniqe = $true
        :Check_Loop foreach ($x in $XList)
        {
            foreach ($y in $YList)
            {
                $ClaimedSpoot = '{0}-{1}' -f $x, $y
                if ($ClaimedSpoots[$ClaimedSpoot] -ne 0)
                {
                    $Uniqe = $false
                    break Check_Loop
                }
            }
        }
        if ($Uniqe)
        {
            #Answer A
            $claim.ClaimID
        }

    }
}
