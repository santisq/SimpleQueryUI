param(
    [parameter(mandatory)]
    [psobject]$SkippedLines
)

$skipForm=New-Object System.Windows.Forms.Form
$skipForm.StartPosition='CenterScreen'
$skipForm.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\PowerShell.exe")
$skipForm.FormBorderStyle='Fixed3D'
$skipForm.KeyPreview=$True
$skipForm.Text='Skipped Entries'
$skipForm.ClientSize=New-Object System.Drawing.Size(($width/2),($height/2.5))
$skipForm.MaximizeBox=$false

$skipLabel=New-Object System.Windows.Forms.Label
$skipLabel.Text='The following entries will be excluded from the query.'
$skipLabel.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$skipLabel.BackColor=[System.Drawing.Color]::FromName('Transparent')
$skipLabel.Size=New-Object System.Drawing.Size(($skipForm.Width-30),30)
$skipLabel.Location=New-Object System.Drawing.Size(10,10)
$skipForm.Controls.Add($skipLabel)

$skipGrid=New-Object System.Windows.Forms.DataGridView
$skipGrid.ReadOnly=$True
$skipGrid.BorderStyle=1
$skipGrid.SelectionMode=1
$skipGrid.Font=New-Object System.Drawing.Font($myFont,9,[System.Drawing.FontStyle]::Regular)
$skipGrid.Location=New-Object System.Drawing.Size(10,40)
$skipGrid.Size=New-Object System.Drawing.Size(($skipForm.Width-40),($skipForm.Height-125))
$skipGrid.Anchor='Top, Bottom, Left'
$skipGrid.AllowUserToAddRows=$false
$skipGrid.AllowUserToResizeColumns=$True
$skipGrid.AllowUserToResizeRows=$True
$skipForm.Controls.Add($skipGrid)

$okSkipBtn=New-Object System.Windows.Forms.Button
$okSkipBtn.Size=New-Object System.Drawing.Size(85,30)
$okSkipBtn.Location=New-Object System.Drawing.Size(($skipForm.Width-113),($skipGrid.Height+45))
$okSkipBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$okSkipBtn.Text="&OK"
$okSkipBtn.Add_Click({
    $mainForm.Activate()
    $skipForm.Dispose()
})
$skipForm.Controls.Add($okSkipBtn)

$exportSkipBtn=New-Object System.Windows.Forms.Button
$exportSkipBtn.Size=New-Object System.Drawing.Size(85,30)
$exportSkipBtn.Location=New-Object System.Drawing.Size(($okSkipBtn.Location.X-$okSkipBtn.Width-3),($skipGrid.Height+45))
$exportSkipBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$exportSkipBtn.Text="&Export"
$exportSkipBtn.Add_Click({
    saveFile -Object $SkippedLines
})
$skipForm.Controls.Add($exportSkipBtn)

$header='Entry','Status'

$skipGrid.ColumnCount=$header.Count
$skipGrid.ColumnHeadersVisible=$true

$i=0;$header|%{
    $skipGrid.Columns[$i].Name=$_
    $i++
}

foreach($line in $skippedLines|sort Status)
{
    $skipGrid.Rows.Add(
        $($header|%{
            $line.$_
        })
    ) > $null
}

$skipGrid.RowHeadersVisible=$false
$skipGrid.ColumnHeadersBorderStyle=2
$skipGrid.AutoSizeColumnsMode=[System.Windows.Forms.DataGridViewAutoSizeColumnMode]::AllCells
$skipGrid.ColumnHeadersHeight=25

$sum=0
$skipGrid.Columns.Width|%{$sum+=$_}

if($sum -lt $skipGrid.Width)
{
    $skipGrid.Columns[-1].AutoSizeMode=[System.Windows.Forms.DataGridViewAutoSizeColumnMode]::Fill
}

$skipForm.Add_KeyDown({
    
    if($_.KeyCode -eq 'Escape'){
        $skipForm.Dispose()
    }
})

$okSkipBtn.Select()

$skipForm.Add_Shown({$skipForm.Activate()})
$skipForm.ShowDialog()