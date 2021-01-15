param(
    [parameter(mandatory)]
    [string[]]$Properties,
    [parameter(mandatory)]
    [string[]]$toProcess,
    [parameter(mandatory)]
    [string]$objectClass
)    

$Global:Grid=New-Object System.Collections.ArrayList
$allObjects=ObjectSearcher -Objects $toProcess -Class $objectClass -Properties $Properties

$propsForm.Dispose()
$toGrid=$allObjects|select -Unique

$progressBar.Maximum=if(!$toGrid.Count){1}else{$toGrid.Count}
$progressBar.Value=0
$progressBar.Step=1

foreach($obj in $toGrid)
{
    $out=New-Object psobject
    
    foreach($prop in $Properties)
    {
        $thisProp=$obj.$prop

        if($thisProp -and $thisProp.GetType() -match 'Collection|\[]'){
            $val=($obj.$prop|out-string).Trim()
        }elseif($thisProp -and $thisProp.GetType() -match 'Int|Boolean'){
            $val=$thisProp
        }elseif($thisProp){
            $val=($thisProp.ToString()).Trim()
        }else{$val=$null}

        $out|Add-Member -MemberType NoteProperty -Name $prop -Value $val
    }
        
    $Global:Grid.Add($out) > $null

    $progressBar.PerformStep()
    $mainForm.Refresh()
    sleep -Milliseconds 1
}

$dataGrid.ColumnCount=$Properties.Count
$dataGrid.ColumnHeadersVisible=$true

$i=0;$Properties|%{
    $dataGrid.Columns[$i].Name=$_
    $i++
}

foreach($object in $Grid)
{
    $dataGrid.Rows.Add(
        $($Properties|%{
            $object.$_
        })
    )
    
    $progressBar.PerformStep()
    $mainForm.Refresh()
    sleep -Milliseconds 1
}

<#
$dataGrid.ColumnHeadersHeight=35
$dataGrid.AutoSizeRowsMode=[System.Windows.Forms.DataGridViewAutoSizeRowsMode]::AllCellsExceptHeaders

$sum=0
$dataGrid.Columns.Width|%{$sum+=$_}

if($sum -lt $dataGrid.Width)
{
    $dataGrid.AutoSizeColumnsMode=[System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill
}else{
    $dataGrid.AutoSizeColumnsMode=[System.Windows.Forms.DataGridViewAutoSizeColumnMode]::DisplayedCells
}

$f=1;$dataGrid.Rows.DefaultCellStyle|%{
    if($f=!$f){
        $_.BackColor=[System.Drawing.Color]::LightGray
    }
}

$dataGrid.RowHeadersDefaultCellStyle.BackColor=[System.Drawing.Color]::LightGray
$dataGrid.RowHeadersDefaultCellStyle.ForeColor=[System.Drawing.Color]::White
#>


$dataGrid.RowHeadersVisible=$false
$dataGrid.ColumnHeadersBorderStyle=2
$dataGrid.AutoSizeColumnsMode=[System.Windows.Forms.DataGridViewAutoSizeColumnMode]::AllCells
$dataGrid.ColumnHeadersHeight=25

$sum=0
$dataGrid.Columns.Width|%{$sum+=$_}

if($sum -lt $dataGrid.Width)
{
    $dataGrid.Columns[-1].AutoSizeMode=[System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill
}

$exportBtn.Enabled=$true
#$clearBtn.Enabled=$true
#$searchBtn.Enabled=$false

$progressBar.Value=0
$progressLbl.Text='Ready'

$exportBtn.Select()