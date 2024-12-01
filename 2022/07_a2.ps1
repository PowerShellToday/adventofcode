
$cmds = Get-Content .\07test.txt
$cmds = Get-Content .\07.txt
$cwd = [System.Collections.ArrayList]@()
$results = @{}

foreach ($cmd in $cmds) {
    switch -regex ($cmd) {
        '^\$\ cd\ /' {
            # cd root
            $cwd.clear() | Out-Null
            $cwd.add('') | Out-Null
            break
        }
        '^\$\ cd \.\.' {
            # cd up
            $cwd.RemoveAt($cwd.LastIndexOf($cwd[-1])) | Out-Null
            break
        }
        '^\$\ cd (.*)$' {
            # cd into folder
            $cwd.add($Matches[1]) | Out-Null
            break
        }
        '^\$\ ls' {
        }
        '^dir (.*)$' {
        }
        '^(\d+) (.*)$' {
            # File
            for ($i = 0; $i -lt $cwd.Count; $i++) {
                $results[($cwd[0..$i] -join '/')] += [int64]$Matches[1]
            }
        }          
        Default {
            Write-Warning $cmd
        }
        
    }
}

($results.Values.Where{ $_ -le 100000 } | Measure-Object -Sum).Sum

$diskSize = 70000000
$needed = 30000000
$unused = $diskSize - $results['']
$Missing = $needed - $unused 
$results.Values.Where{ $_ -ge $Missing } | Sort-Object | Select-Object -First 1
