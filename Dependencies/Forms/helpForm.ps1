$helpForm=New-Object System.Windows.Forms.Form
$helpForm.ClientSize=New-Object System.Drawing.Size(950,530)
$helpForm.StartPosition='CenterScreen'
$helpForm.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\PowerShell.exe")
$helpForm.FormBorderStyle='Fixed3D'
$helpForm.AutoScalemode='DPI'
$helpForm.KeyPreview=$True
$helpForm.TopMost=$true
$helpForm.Text='Help'
$helpForm.MaximizeBox=$false

$helpTxtBox=New-Object System.Windows.Forms.TextBox
$helpTxtBox.Text=$(cat "$depPath\Help.txt"|out-string)
$helpTxtBox.Multiline=$True
$helpTxtBox.ReadOnly=$True
$helpTxtBox.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$helpTxtBox.Size=New-Object System.Drawing.Size(930,($helpForm.Height-100))
$helpTxtBox.Location=New-Object System.Drawing.Size(10,10)


$helpBtn=New-Object System.Windows.Forms.Button
$helpBtn.Size=New-Object System.Drawing.Size(75,30)
$helpBtn.Location=New-Object System.Drawing.Size(($helpForm.Width-104),$($helpForm.Height-84))
$helpBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$helpBtn.Text="&Close"
$helpBtn.Enabled=$True
$helpBtn.Add_Click({$helpForm.Dispose()})

$helpForm.Controls.Add($helpBtn)
$helpForm.Controls.Add($helpTxtBox)
$helpBtn.Select()

$helpForm.Add_KeyDown({
    
    if($_.KeyCode -eq 'Escape'){
        $this.Dispose()
    }
})

$helpForm.ShowDialog()