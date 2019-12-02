function restore-Intcode {
    param (
        [Parameter(Mandatory = $true)]
        [int32[]]
        $optocode
    )
    $opcodeCount = [Math]::Floor($optocode.Count / 4)
    Write-Verbose "opcodeCount $opcodeCount"
    for ($opcodebase = 0; $opcodebase -lt ($optocode.Count - 1 ); $opcodebase += 4) {
        
        $opcode = $optocode[$opcodebase]
        $opval1 = $optocode[$opcodebase + 1]
        $opval2 = $optocode[$opcodebase + 2]
        $opval3 = $optocode[$opcodebase + 3]
        Write-Verbose "opcode $opcode"
        switch ($opcode) {
            1 {
                $optocode[$opval3] = $optocode[$opval1] + $optocode[$opval2]
            }
            2 {
                $optocode[$opval3] = $optocode[$opval1] * $optocode[$opval2]
            }
            99 {
                $opcodebase = $optocode.Count + 100
                break
            }
            Default { 
                throw
            }
        }
    }
    $optocode
}
