[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[System.Windows.Forms.Application]::EnableVisualStyles()

$mainForm=New-Object System.Windows.Forms.Form
$mainForm.StartPosition='CenterScreen'
$mainForm.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\PowerShell.exe")
$mainForm.KeyPreview=$True
$mainForm.FormBorderStyle='Fixed3D'
#$mainForm.TopMost=$true
$mainForm.Text='Simple Query'
$mainForm.WindowState='Maximized'

$bounds=($mainForm.CreateGraphics()).VisibleClipBounds.Size

$description='Simple Query can help you perform Active Directory searchs for Users, Computers or Groups in bulk and export the data to different formats.
Use the ''Search'' button to input all the objects you wish to query.'

$mainLbl=New-Object System.Windows.Forms.Label
$mainLbl.Size=New-Object System.Drawing.Size(($bounds.Width-300),30)
$mainLbl.Location=New-Object System.Drawing.Size(10,20)
$mainLbl.Text=$description
$mainLbl.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$mainForm.Controls.Add($mainLbl)

$dataGrid=New-Object System.Windows.Forms.DataGridView
$dataGrid.Size=New-Object System.Drawing.Size(($bounds.Width-20),$($bounds.Height-140))
$dataGrid.Location=New-Object System.Drawing.Size(10,60)
$dataGrid.Font=New-Object System.Drawing.Font($myFont,9,[System.Drawing.FontStyle]::Regular)
#$dataGrid.ColumnHeadersDefaultCellStyle.Font=New-Object System.Drawing.Font($myFont,9,[System.Drawing.FontStyle]::Bold)
$dataGrid.DefaultCellStyle.WrapMode='True'
$dataGrid.AllowUserToResizeRows=$True
$dataGrid.AllowUserToResizeColumns=$True
$dataGrid.AllowUserToAddRows=$false
$dataGrid.SelectionMode=0
$dataGrid.MultiSelect=$false
$dataGrid.ReadOnly=$true
$dataGrid.EnableHeadersVisualStyles=$True
$datagrid.Anchor='Top, Bottom, Left'
$mainForm.Controls.Add($dataGrid)

$exitBtn=New-Object System.Windows.Forms.Button
$exitBtn.Size=New-Object System.Drawing.Size(85,30)
$exitBtn.Location=New-Object System.Drawing.Size(($dataGrid.Width-74),($dataGrid.Height+70))
$exitBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$exitBtn.Text="E&xit"
$exitBtn.Add_Click({
    $mainForm.Dispose()
})

$helpBtn=New-Object System.Windows.Forms.Button
$helpBtn.Size=New-Object System.Drawing.Size(85,30)
$helpBtn.Location=New-Object System.Drawing.Size(($exitBtn.Location.X-$exitBtn.Width-3),($dataGrid.Height+70))
$helpBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$helpBtn.Text="&Help"
$helpBtn.Add_Click({
    . "$depPath\Forms\helpForm.ps1"
})

<#
$clearBtn=New-Object System.Windows.Forms.Button
$clearBtn.Size=New-Object System.Drawing.Size(85,30)
$clearBtn.Location=New-Object System.Drawing.Size(($dataGrid.Width-74),20)
$clearBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$clearBtn.Text="&Clear"
$clearBtn.Enabled=$false
$clearBtn.Add_Click({
    $dataGrid.Rows.Clear()
    $dataGrid.Refresh()
    $clearBtn.Enabled=$false
    $exportBtn.Enabled=$false
    $searchBtn.Enabled=$True
    $dataGrid.ResetText()
    $dataGrid.Columns.Clear()
})
#>

$exportBtn=New-Object System.Windows.Forms.Button
$exportBtn.Size=New-Object System.Drawing.Size(85,30)
#$exportBtn.Location=New-Object System.Drawing.Size(($clearBtn.Location.X-$clearBtn.Width-3),20)
$exportBtn.Location=New-Object System.Drawing.Size(($dataGrid.Width-74),20)
$exportBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$exportBtn.Text="&Export"
$exportBtn.Enabled=$false
$exportBtn.Add_Click({
    saveFile -Object $Grid
})

$searchBtn=New-Object System.Windows.Forms.Button
$searchBtn.Size=New-Object System.Drawing.Size(85,30)
$searchBtn.Location=New-Object System.Drawing.Size(($exportBtn.Location.X-$exportBtn.Width-3),20)
$searchBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$searchBtn.Text="&Search"
$searchBtn.Add_Click({
    
    if(. "$depPath\ModuleCheck\checkAD.ps1"){

        $exportBtn.Enabled=$false
        $dataGrid.Rows.Clear()
        $dataGrid.Refresh()
        $dataGrid.ResetText()
        $dataGrid.Columns.Clear()

        . "$depPath\Forms\searchForm.ps1"

    }
        
})

$mainForm.Controls.Add($searchBtn)
$mainForm.Controls.Add($exportBtn)
#$mainForm.Controls.Add($clearBtn)
$mainForm.Controls.Add($helpBtn)
$mainForm.Controls.Add($exitBtn)

$progressBar=New-Object System.Windows.Forms.ProgressBar
$progressBar.Value=0
$progressBar.Style=1
$progressBar.Size=New-Object System.Drawing.Size(($bounds.Width-20),20)
$progressBar.Location=New-Object System.Drawing.Size(10,($bounds.Height-25))
$mainForm.Controls.Add($progressBar)

$progressLbl=New-Object System.Windows.Forms.Label
$progressLbl.Size=New-Object System.Drawing.Size(300,20)
$progressLbl.Location=New-Object System.Drawing.Size(10,($bounds.Height-48))
$progressLbl.Text='Ready'
$progressLbl.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$mainForm.Controls.Add($progressLbl)

$mainForm.Add_KeyDown({
    
    if($_.KeyCode -eq 'Escape'){
        $this.Dispose()
    }
})

$searchBtn.Select()

$mainForm.Add_Shown({$mainForm.Activate()})
$mainForm.ShowDialog()