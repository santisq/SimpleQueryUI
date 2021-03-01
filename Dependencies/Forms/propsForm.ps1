param(
    [parameter(mandatory)]
    [string[]]$Properties,
    [parameter(mandatory)]
    [string[]]$toProcess,
    [parameter(mandatory)]
    [string]$ObjectClass,
    [string[]]$thisSelectedProps
)

$propsForm=New-Object System.Windows.Forms.Form
$propsForm.StartPosition='CenterScreen'
$propsForm.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\PowerShell.exe")
$propsForm.FormBorderStyle='Fixed3D'
$propsForm.KeyPreview=$True
$propsForm.Text='Select Properties'
$propsForm.ClientSize=New-Object System.Drawing.Size(($width/3),($height/2))
$propsForm.MaximizeBox=$false

$availPropsLbl=New-Object System.Windows.Forms.Label
$availPropsLbl.Text='Add all the attributes you would like to display on the DataGrid.'
$availPropsLbl.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$availPropsLbl.BackColor=[System.Drawing.Color]::FromName('Transparent')
$availPropsLbl.Size=New-Object System.Drawing.Size(($propsForm.Width-30),20)
$availPropsLbl.Location=New-Object System.Drawing.Size(10,15)
$propsForm.Controls.Add($availPropsLbl)

$propsListCBox=New-Object System.Windows.Forms.ComboBox
$propsListCBox.Size=New-Object System.Drawing.Size(($propsForm.Width-218),40)
$propsListCBox.Location=New-Object System.Drawing.Size(10,40)
$propsListCBox.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$propsListCBox.DropDownStyle='DropDown'#[System.Windows.Forms.ComboBoxStyle]::DropDown
$propsListCBox.AutoCompleteSource='ListItems'
$propsListCBox.AutoCompleteMode='SuggestAppend'
$Properties|%{$propsListCBox.Items.Add($_)} > $null
$propsListCBox.Add_KeyDown({
    if($_.KeyCode -eq 'Enter' -and $propsListCBox.SelectedItem -notin $selectedPropsLst.Items){
        $selectedPropsLst.Items.Add($propsListCBox.SelectedItem)
    }

    if(!$selectedPropsLst.Items){
        $confirmPropsBtn.Enabled=$false
    }else{
        $confirmPropsBtn.Enabled=$True
    }
})
$propsListCBox.SelectedIndex=0
$propsForm.Controls.Add($propsListCBox)

$addBtn=New-Object System.Windows.Forms.Button
$addBtn.Size=New-Object System.Drawing.Size(85,27)
$addBtn.Location=New-Object System.Drawing.Size(($propsListCBox.Width+15),38)
$addBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$addBtn.Text="&Add"
$addBtn.Add_Click({
    if($propsListCBox.SelectedItem -notin $selectedPropsLst.Items){
        $selectedPropsLst.Items.Add($propsListCBox.SelectedItem)
    }
    if(!$selectedPropsLst.Items){
        $confirmPropsBtn.Enabled=$false
    }else{
        $confirmPropsBtn.Enabled=$True
    }
})
$propsForm.Controls.Add($addBtn)

$removeBtn=New-Object System.Windows.Forms.Button
$removeBtn.Size=New-Object System.Drawing.Size(85,27)
$removeBtn.Location=New-Object System.Drawing.Size(($addBtn.Width+$propsListCbox.Width+18),38)
$removeBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$removeBtn.Text="&Remove"
$removeBtn.Add_Click({
    $selected=@($selectedPropsLst.SelectedItems)
    for($i=0;$i -lt $selected.Count;$i++)
    {
        $selectedPropsLst.Items.Remove($selected[$i])
    }
    $selectedPropsLst.ClearSelected()
    
    if(!$selectedPropsLst.Items){
        $confirmPropsBtn.Enabled=$false
    }else{
        $confirmPropsBtn.Enabled=$True
    }
})
$propsForm.Controls.Add($removeBtn)

$selectedPropsLst=New-Object System.Windows.Forms.ListBox
$selectedPropsLst.Size=New-Object System.Drawing.Size(($propsForm.Width-40),($propsForm.Height-150))
$selectedPropsLst.Location=New-Object System.Drawing.Size(10,70)
$selectedPropsLst.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$selectedPropsLst.SelectionMode=3
if($thisSelectedProps)
{
    $thisSelectedProps|%{
        $selectedPropsLst.Items.Add($_)
    }
}
else
{
    $selectedPropsLst.Items.Add('Name') > $null
}
$propsForm.Controls.Add($selectedPropsLst)

$addAllBtn=New-Object System.Windows.Forms.Button
$addAllBtn.Size=New-Object System.Drawing.Size(85,27)
$addAllBtn.Location=New-Object System.Drawing.Size(10,($selectedPropsLst.Height+73))
$addAllBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$addAllBtn.Text="A&dd All"
$addAllBtn.Add_Click({
    $Properties|%{
        if($_ -notin $selectedPropsLst.Items){
            $selectedPropsLst.Items.Add($_) > $null
        }
    }
    
    if(!$selectedPropsLst.Items){
        $confirmPropsBtn.Enabled=$false
    }else{
        $confirmPropsBtn.Enabled=$True
    }
})
$propsForm.Controls.Add($addAllBtn)

$removeAllBtn=New-Object System.Windows.Forms.Button
$removeAllBtn.Size=New-Object System.Drawing.Size(85,27)
$removeAllBtn.Location=New-Object System.Drawing.Size(($addAllBtn.Location.X+$addAllBtn.Width+3),($selectedPropsLst.Height+73))
$removeAllBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$removeAllBtn.Text="R&emove All"
$removeAllBtn.Add_Click({
    $thisItems=@($selectedPropsLst.Items)
    for($i=0;$i -lt $thisItems.Count;$i++)
    {
        $selectedPropsLst.Items.Remove($thisItems[$i])
    }
    $confirmPropsBtn.Enabled=$false
})
$propsForm.Controls.Add($removeAllBtn)

$confirmPropsBtn=New-Object System.Windows.Forms.Button
$confirmPropsBtn.Size=New-Object System.Drawing.Size(85,27)
$confirmPropsBtn.Location=New-Object System.Drawing.Size(($propsForm.Width-$confirmPropsBtn.Width-30),($selectedPropsLst.Height+73))
$confirmPropsBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$confirmPropsBtn.Text="&OK"
$confirmPropsBtn.Add_Click({
    
    $propsForm.Hide()
    $selectedProps=$selectedPropsLst.Items
    $mainForm.Activate()
    New-Variable -Name thisProps -Value $selectedProps -Scope Global -Force
    . "$depPath\Listeners\toGridEventListener.ps1" -Properties $selectedProps -toProcess $toProcess -ObjectClass $ObjectClass

})
$propsForm.Controls.Add($confirmPropsBtn)

$cancelPropsBtn=New-Object System.Windows.Forms.Button
$cancelPropsBtn.Size=New-Object System.Drawing.Size(85,27)
$cancelPropsBtn.Location=New-Object System.Drawing.Size(($confirmPropsBtn.Location.X-88),($selectedPropsLst.Height+73))
$cancelPropsBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$cancelPropsBtn.Text="&Cancel"
$cancelPropsBtn.Add_Click({
    $progressLbl.Text='Ready'
    $progressBar.Value=0
    $propsForm.Dispose()
})
$propsForm.Controls.Add($cancelPropsBtn)

$propsForm.Add_KeyDown({
    
    if($_.KeyCode -eq 'Escape'){
        $progressLbl.Text='Ready'
        $progressBar.Value=0
        $propsForm.Dispose()
    }
})

$propsForm.Add_Closing({
    $progressLbl.Text='Ready'
    $progressBar.Value=0
})

$progressLbl.Text='Select query attributes...'

$propsForm.Add_Shown({$propsForm.Activate()})
$propsForm.ShowDialog() > $null