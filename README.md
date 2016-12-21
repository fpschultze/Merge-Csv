[![Build status](https://ci.appveyor.com/api/projects/status/f3cl7slwdhpv573q?svg=true)](https://ci.appveyor.com/project/fpschultze/merge-csv)

# Merge-Csv PowerShell Function

.SYNOPSIS
Merge CSV files

.SYNOPSIS
Merges multiple CSV files within a given directory into one CSV file.

.EXAMPLE
Merge-Csv -Path C:\foo -ResultFile .\bar.csv

.EXAMPLE
Merge-Csv -Path C:\foo -ResultFile .\bar.csv -Property foo, bar

.EXAMPLE
Merge-Csv -Path C:\foo -ResultFile .\bar.csv -Delimiter ';'
