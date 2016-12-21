[![Build status](https://ci.appveyor.com/api/projects/status/f3cl7slwdhpv573q?svg=true)](https://ci.appveyor.com/project/fpschultze/merge-csv)

# Merge-Csv PowerShell Function

Merges multiple CSV files within a given directory into one CSV file.

Merge-Csv -Path C:\foo -ResultFile .\bar.csv

Merge-Csv -Path C:\foo -ResultFile .\bar.csv -Property foo, bar

Merge-Csv -Path C:\foo -ResultFile .\bar.csv -Delimiter ';'
