$Passports = (Get-Content .\04\test.text -Raw).replace("`r`n", "`n").Split("`n`n")
$Passports = (Get-Content '.\04\data.txt' -Raw).replace("`r`n", "`n").Split("`n`n")

$ValidPassPorts = 0

$Regex = "^byr:(?'byr'\d{4}) (cid:\d* |)ecl:(amb|blu|brn|gry|grn|hzl|oth) eyr:(?'eyr'\d{4}) hcl:#[0-9a-f]{6} hgt:(?'hgt'\d{2,3})(?'hgttoken'(in|cm)) iyr:(?'iyr'\d{4}) pid:\d{9}$"




foreach ($Passport in $Passports)
{

    $Items = $Passport.Replace("`n", ' ').Split(' ').Where{ $_ }.trim() | Sort-Object
    $PassportLine = $Items -join ' '
    if ($PassportLine -match $Regex)
    {
        $Check = $Matches.eyr -ge 2020 -and
        $Matches.eyr -le 2030 -and
        $Matches.iyr -ge 2010 -and
        $Matches.iyr -le 2020 -and
        $Matches.byr -ge 1920 -and
        $Matches.byr -le 2002 -and
        (
            $Matches.hgttoken -eq 'cm' -and
            $Matches.hgt -ge 150 -and
            $Matches.hgt -le 193
        ) -or (
            $Matches.hgttoken -eq 'in' -and
            $Matches.hgt -ge 59 -and
            $Matches.hgt -le 76
        )
        if ($Check)
        {
            $ValidPassPorts++
        }
    }
}

$ValidPassPorts


break
foreach ($Passport in $Passports)
{

    $Items = $Passport.Replace("`n", ' ').Split(' ').Where{ $_ }.trim() | Sort-Object
    $PropString = $Items.foreach{ $_.split(':')[0] } -join ' '
    if ($PropString -match 'byr (cid |)ecl eyr hcl hgt iyr pid')
    {
        $ValidPassPorts ++

    }
}

$ValidPassPorts
