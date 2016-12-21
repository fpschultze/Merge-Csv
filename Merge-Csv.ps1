<#
  .SYNOPSIS
  Merge CSV files

  .DESCRIPTION
  Merges multiple CSV files within a given directory into one CSV file.

  .EXAMPLE
  Merge-Csv -Path C:\foo -ResultFile .\bar.csv

  .EXAMPLE
  Merge-Csv -Path C:\foo -ResultFile .\bar.csv -Property foo, bar

  .EXAMPLE
  Merge-Csv -Path C:\foo -ResultFile .\bar.csv -Delimiter ';'

  .NOTES
  Author: Frank Peter Schultze
  Date: 2016-12-21
  Version: 1.0
#>
function Merge-Csv
{
  Param
  (
    # Path where the .csv files reside
    [Parameter(Mandatory=$true)]
    [string]
    $Path,

    # Result file
    [Parameter(Mandatory=$true)]
    [string]
    $ResultFile,

    # Delimiter (default character is comma)
    [Parameter()]
    [string]
    $Delimiter = ',',

    # Properties (default is all properties)
    [Parameter()]
    [string[]]
    $Property = '*'
  )

  function Select-CsvContent
  {
    param
    (
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      $InputObject,

      [Parameter(Mandatory=$true)]
      $Delimiter,

      [Parameter(Mandatory=$true)]
      $Property
    )
    process
    {
      Get-Content -Path $InputObject.FullName |
        ConvertFrom-Csv -Delimiter $Delimiter |
          Select-Object -Property $Property
    }
  }

  function Where-NotFileName
  {
    param
    (
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
      $InputObject,

      [Parameter(Mandatory=$true)]
      $FilePath
    )
    process
    {
      if ($InputObject.FullName -ne $FilePath)
      {
        $InputObject
      }
    }
  }

  $ErrorActionPreference = 'Stop'

  try
  {
    Write-Output $null >> $ResultFile
    $ResultFilePath = (Get-ChildItem -Path $ResultFile).FullName

    Get-ChildItem -Path $Path -Filter *.csv |
      Where-NotFileName -FilePath $ResultFilePath |
        Select-CsvContent -Property $Property -Delimiter $Delimiter |
          Export-Csv -Path $ResultFilePath -Delimiter $Delimiter -Force -NoTypeInformation
  }
  catch
  {
    $_.Exception.Message | Write-Error
  }
}
