function saveFile{
param(
    [parameter(mandatory)]
    [array]$Object
)

$exportBar={
    $progressLbl.Text='Exporting data...'
    $progressBar.Style=1
    $progressBar.Step=10
    $progressBar.Maximum=100
    while($progressBar.Value -lt 100){
        $progressBar.PerformStep()
        $mainForm.Refresh()
        sleep -Milliseconds 3
    }
}

$exportBarComplete={
    $progressLbl.Text='Ready'
    $progressBar.Style=1
    $progressBar.Value=0
    $progressBar.Refresh()
    $mainForm.Refresh()
    sleep -Milliseconds 1

    $hash=@{
        Title='Data Export'
        Message='The data was successfully exported. Go to Destination Folder?'
        Buttons='YesNo'
        Icon='Information'
    }
    
    $result=Show-MessageBox @hash
    
    if($result -eq 'Yes')
    {        
        explorer.exe /select,$fullPath
    }
}

$saveFilter=@'
Microsoft Excel Open XML Spreadsheet (*.xlsx)|*.xlsx|
Comma-separated Values (*.csv)|*.csv|
Text File (*.txt)|*.txt|
Extensible Markup Language (*.xml)|*.xml|
JavaScript Object Notation (*.json)|*.JSON
'@

$browse=New-Object System.Windows.Forms.SaveFileDialog
$browse.InitialDirectory=[environment]::GetFolderPath('MyDocuments')
$browse.Filter=$saveFilter

$browse.ShowDialog() > $null

if($browse.FileName){

    $fullPath=$browse.FileName
    $fileName=Split-Path $browse.FileName -Leaf

    switch -Regex($fileName)
    {
        '\.xlsx$'{
        
            if(. "$depPath\ModuleCheck\checkExcel.ps1")
            {
                &$exportBar

                if(Test-Path $fullPath){
                    Remove-Item $fullPath -Force -EA SilentlyContinue
                }

                $defProps=@{
                    AutoSize=$true
                    TableName='simpleADexport'
                    TableStyle='Medium11'
                    BoldTopRow=$true
                    WorksheetName='SimpleAD'
                    PassThru=$true
                }
        
                $xls=$object|Export-Excel $fullPath @defProps
                $ws=$xls.Workbook.Worksheets[$defProps.Worksheetname]
                for($i=1;$i -le $ws.Dimension.Columns;$i++){
                    $ws.Column($i).Style.WrapText=$true
                    $ws.Column($i).Style.VerticalAlignment='Top'
                }
                $ws.View.ShowGridLines=$false
                Close-ExcelPackage $xls
            }
        
            &$exportBarComplete
        }

        '\.csv$'{
        
            &$exportBar
            $object|Export-Csv -NoTypeInformation $fullPath
            &$exportBarComplete
        }

        '\.txt$'{
            &$exportBar
            $object|Out-File $fullPath -Encoding UTF8
            &$exportBarComplete
        }

        '\.xml$'{
            &$exportBar
            $object|Export-Clixml $fullPath -Encoding UTF8
            &$exportBarComplete
        }

        '\.json$'{
            &$exportBar        
            $object|ConvertTo-Json|Out-File $fullPath -Encoding UTF8
            &$exportBarComplete
        }
    }

    }

}