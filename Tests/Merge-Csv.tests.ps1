$ScriptRoot = Split-Path -Parent $PSScriptRoot
$ScriptFile = (Split-Path -Leaf $PSCommandPath) -replace '\.tests\.ps1$', '.ps1'
. "$ScriptRoot\$ScriptFile"

function New-Csv ($Path, $Delimiter) {
@'
Id{0}Date{0}Computername
{1}{0}{2:yyyyMMddHHmmss}{0}{3}
'@ -f $Delimiter, [guid]::NewGuid().Guid, (Get-Date), $env:COMPUTERNAME >$Path
}

#$TestPath = Join-Path -Path $env:TEMP -ChildPath ([guid]::NewGuid().Guid)
#$null = New-Item -Path $TestPath -ItemType Directory

Describe 'Merge-Csv' {

  $TestPath = 'TESTDRIVE:\'
  $TestFile1 = Join-Path -Path $TestPath -ChildPath 'foo.csv'
  $TestFile2 = Join-Path -Path $TestPath -ChildPath 'bar.csv'
  $TestResultFile  = Join-Path -Path $TestPath -ChildPath 'foobar.csv'

  Context 'with comma-delimited CSV files' {

    $char = ','
    New-Csv -Path $TestFile1 -Delimiter $char
    New-Csv -Path $TestFile2 -Delimiter $char

    It 'runs without errors' {
      {Merge-Csv -Path $TestPath -ResultFile $TestResultFile} | Should Not Throw
    }
    It 'the result file exists' {
      $TestResultFile | Should Exist
    }
    It 'the result file contains each csv content' {
      $TestResultFileContent = Get-Content -Path $TestResultFile | ConvertFrom-Csv
      $TestFile1Content = Get-Content -Path $TestFile1 | ConvertFrom-Csv
      $TestFile2Content = Get-Content -Path $TestFile2 | ConvertFrom-Csv
      (Compare-Object $TestFile1Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile1Content.Name
      (Compare-Object $TestFile2Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile2Content.Name
    }
  }

  Context 'with a subset of properties' {

    It 'runs without errors' {
      {Merge-Csv -Path $TestPath -ResultFile $TestResultFile -Property Id, Date} | Should Not Throw
    }
    It 'the result file contains a subset of each csv content' {
      $TestResultFileContent = Get-Content -Path $TestResultFile | ConvertFrom-Csv
      $TestFile1Content = Get-Content -Path $TestFile1 | ConvertFrom-Csv
      $TestFile2Content = Get-Content -Path $TestFile2 | ConvertFrom-Csv
      (Compare-Object $TestFile1Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile1Content.Name
      (Compare-Object $TestFile2Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile2Content.Name
      ($TestResultFileContent | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name).Count | Should Be 2
    }
  }

  Context 'Running with semicolon-delimited csv files' {

    $char = ';'
    New-Csv -Path $TestFile1 -Delimiter $char
    New-Csv -Path $TestFile2 -Delimiter $char

    It 'runs without errors' {
      {Merge-Csv -Path $TestPath -ResultFile $TestResultFile -Delimiter $char} | Should Not Throw
    }
    It 'result file should exist' {
      $TestResultFile | Should Exist
    }
    It 'result file should contain each csv content' {
      $TestResultFileContent = Get-Content -Path $TestResultFile | ConvertFrom-Csv -Delimiter $char
      $TestFile1Content = Get-Content -Path $TestFile1 | ConvertFrom-Csv -Delimiter $char
      $TestFile2Content = Get-Content -Path $TestFile2 | ConvertFrom-Csv -Delimiter $char
      (Compare-Object $TestFile1Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile1Content.Name
      (Compare-Object $TestFile2Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile2Content.Name
    }
  }

  Context 'with a subset of properties' {

    $char = ';'

    It 'runs without errors' {
      {Merge-Csv -Path $TestPath -ResultFile $TestResultFile -Delimiter $char -Property Id, Date} | Should Not Throw
    }
    It 'the result file contains a subset of each csv content' {
      $TestResultFileContent = Get-Content -Path $TestResultFile | ConvertFrom-Csv -Delimiter $char
      $TestFile1Content = Get-Content -Path $TestFile1 | ConvertFrom-Csv -Delimiter $char
      $TestFile2Content = Get-Content -Path $TestFile2 | ConvertFrom-Csv -Delimiter $char
      (Compare-Object $TestFile1Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile1Content.Name
      (Compare-Object $TestFile2Content $TestResultFileContent -Property Name -IncludeEqual -ExcludeDifferent).Name | Should Be $TestFile2Content.Name
      ($TestResultFileContent | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name).Count | Should Be 2
    }
  }
}

#Remove-Item -Path $TestPath -Recurse -Force
