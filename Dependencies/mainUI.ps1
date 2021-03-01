$mainForm=New-Object System.Windows.Forms.Form
$mainForm.StartPosition='CenterScreen'
$mainForm.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\PowerShell.exe")
$mainForm.KeyPreview=$True
$mainForm.FormBorderStyle='Fixed3D'
$mainForm.Text='Simple Query'
$mainForm.WindowState='Maximized'

$bounds=($mainForm.CreateGraphics()).VisibleClipBounds.Size

$description='Simple Query can help you perform Active Directory bulk queries for Users, Computers or Groups and export to different formats.
Use the ''Search'' button to input all the objects you wish to query.'

$mainLbl=New-Object System.Windows.Forms.Label
$mainLbl.Size=New-Object System.Drawing.Size(($bounds.Width-450),50)
$mainLbl.Location=New-Object System.Drawing.Size(10,10)
$mainLbl.Text=$description
$mainLbl.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$mainForm.Controls.Add($mainLbl)

$dataGrid=New-Object System.Windows.Forms.DataGridView
$dataGrid.Size=New-Object System.Drawing.Size(($bounds.Width-20),($bounds.Height-140))
$dataGrid.Location=New-Object System.Drawing.Size(10,60)
$dataGrid.Font=New-Object System.Drawing.Font($myFont,9,[System.Drawing.FontStyle]::Regular)
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

$exportBtn=New-Object System.Windows.Forms.Button
$exportBtn.Size=New-Object System.Drawing.Size(85,30)
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
        . "$depPath\Forms\searchForm.ps1"
    }
        
})

$refreshBtn=New-Object System.Windows.Forms.Button
$refreshBtn.Size=New-Object System.Drawing.Size(85,30)
$refreshBtn.Location=New-Object System.Drawing.Size(($searchBtn.Location.X-$searchBtn.Width-3),20)
$refreshBtn.Enabled=$false
$refreshBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$refreshBtn.Text="&Refresh"
$refreshBtn.Add_Click({
    . "$depPath\Listeners\toGridEventListener.ps1" -Properties $thisProps -toProcess $toProcess -ObjectClass $selectedClass
})

$changePropBtn=New-Object System.Windows.Forms.Button
$changePropBtn.Size=New-Object System.Drawing.Size(125,30)
$changePropBtn.Location=New-Object System.Drawing.Size(($refreshBtn.Location.X-$refreshBtn.Width-43),20)
$changePropBtn.Enabled=$false
$changePropBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$changePropBtn.Text="Select &Properties"
$changePropBtn.Add_Click({
    . "$depPath\Forms\propsForm.ps1" -Properties $propsArray -toProcess $toProcess -ObjectClass $selectedClass -thisSelectedProps $thisProps
})

$mainForm.Controls.Add($changePropBtn)
$mainForm.Controls.Add($refreshBtn)
$mainForm.Controls.Add($searchBtn)
$mainForm.Controls.Add($exportBtn)
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