$cmds = Get-Content .\07test.txt
$cmds = Get-Content .\07.txt
$cwd = [System.Collections.ArrayList]@()
# Low 1378400

$res = foreach ($cmd in $cmds) {
    switch -regex ($cmd) {
        '^\$\ cd\ /' {
            # cd root
            $cwd.clear() | Out-Null
            $cwd.add('') | Out-Null
            [PSCustomObject]@{
                Type  = 'Dir'
                Path  = '/'
                Size  = 0
                Level = $cwd.Count
            }
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
            # ls
            #$cmd
        }
        '^dir (.*)$' {
            # Directory
            #$cmd
            #$Matches
            [PSCustomObject]@{
                Type  = 'Dir'
                Path  = (($cwd -join '/') + '/' + $Matches[1])
                Size  = 0
                Level = $cwd.Count
            }
        }
        '^(\d+) (.*)$' {
            # File
            #$cmd
            #$Matches
            [PSCustomObject]@{
                Type  = 'File'
                Path  = (($cwd -join '/') + '/' + $Matches[2])
                Size  = [int64]$Matches[1]
                Level = $cwd.Count
            }
        }          
        Default {
            Write-Warning $cmd
        }
        
    }
}

#$res | Sort-Object path

$sum = $res.Where{ $_.Type -eq 'Dir' } | ForEach-Object {
    $Dir = $_
    $Pattern = '^' + [regex]::Escape($Dir.path)
    #$Dir.path
    #($res.Where{ $_.Type -eq 'File' -and $_.Path -match $Pattern } | Measure-Object -Sum -Property size).sum
    $size = ($res.Where{ $_.Type -eq 'File' -and $_.Path -match $Pattern } | Measure-Object -Sum -Property size).sum
    if ($size -le 100000 ) {
        <# Action to perform if the condition is true #>
        #[PSCustomObject]@{
        #    Path = $Dir.path
        #    Size = $size
        #}
    }
    [PSCustomObject]@{
        Path = $Dir.path
        Size = $size
    }
}
$sum |where size -le 100000 |Measure-Object -Sum -Property Size
$sum | Measure-Object -Sum -Property Size