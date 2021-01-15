[void][Reflection.Assembly]::LoadWithPartialName('System.Windows.Forms')
[void][Reflection.Assembly]::LoadWithPartialName('System.Drawing')
[System.Windows.Forms.Application]::EnableVisualStyles()

$bounds=[System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$width=$bounds.Width
$height=$bounds.Height

$searchForm=New-Object System.Windows.Forms.Form
$searchForm.StartPosition='CenterScreen'
$searchForm.Icon=[System.Drawing.Icon]::ExtractAssociatedIcon("$PSHOME\PowerShell.exe")
$searchForm.FormBorderStyle='Fixed3D'
$searchForm.KeyPreview=$True
$searchForm.Text='Add Entries to Query'
$searchForm.Width=$width-660
$searchForm.Height=$height-380
$searchForm.MaximizeBox=$false

$searchLabelText=@'
Add the AD object or objects you want to query, each object should be separated by a new line.
NOTE: Consider that only the attributes of the first entry will be displayed for all entries.

Accepted Attributes:
Name, SamAccountName, DistinguishedName and UserPrincipalName
'@

$searchLabel=New-Object System.Windows.Forms.Label
$searchLabel.Text=$searchLabelText
$searchLabel.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$searchLabel.BackColor=[System.Drawing.Color]::FromName('Transparent')
$searchLabel.Size=New-Object System.Drawing.Size(($width-690),85)
$searchLabel.Location=New-Object System.Drawing.Size(10,10)
$searchForm.Controls.Add($searchLabel)

<#
$userRadio=New-Object System.Windows.Forms.RadioButton
$userRadio.Text='User'
$userRadio.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$userRadio.Location=New-Object System.Drawing.Size(15,25)
$userRadio.Size=New-Object System.Drawing.Size(60,25)

$groupRadio=New-Object System.Windows.Forms.RadioButton
$groupRadio.Text='Group'
$groupRadio.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$groupRadio.Location=New-Object System.Drawing.Size(15,55)
$groupRadio.Size=New-Object System.Drawing.Size(70,25)

$computerRadio=New-Object System.Windows.Forms.RadioButton
$computerRadio.Text='Computer'
$computerRadio.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$computerRadio.Location=New-Object System.Drawing.Size(15,85)
$computerRadio.Size=New-Object System.Drawing.Size(85,25)
#>

$searchTxtBoxText=@'
example.object1
example.object2
example.object3
...
'@

$searchTxtBox=New-Object System.Windows.Forms.TextBox
$searchTxtBox.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$searchTxtBox.Size=New-Object System.Drawing.Size(($searchForm.Width-40),($searchForm.Height-210))
$searchTxtBox.Location=New-Object System.Drawing.Size(10,($searchLabel.Location.Y+90))
$searchTxtBox.Multiline=$true
$searchTxtBox.ScrollBars='Vertical'
$searchTxtBox.Text=$searchTxtBoxText
$searchTxtBox.ShortcutsEnabled=$True
$searchTxtBox.Add_TextChanged({

    $c1=[String]::IsNullOrWhiteSpace($this.Text)
    $c2=($searchTxtBoxText -split '\s+') -match $this.Text 
    
    if($c1 -or $c2){
        $searchOKbtn.Enabled=$false
    }else{
        $searchOKbtn.Enabled=$true
    }

})
$searchForm.Controls.Add($searchTxtBox)

$searchOKbtn=New-Object System.Windows.Forms.Button
$searchOKbtn.Size=New-Object System.Drawing.Size(75,30)
$searchOKbtn.Location=New-Object System.Drawing.Size(($searchForm.Size.Width-104),($searchForm.Size.Height-80))
$searchOKbtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$searchOKbtn.Text="&Validate"
$searchOKbtn.Enabled=$false
$searchOKbtn.Add_Click({

    $searchForm.Hide()
    $mainForm.Activate()
    $lines=$searchTxtBox.Text -split '\r|\n|\r\n'|?{$_}|%{$_.trim()}
    $objectClass=$classCBox.SelectedItem

    . "$depPath\Listeners\searchEventListener.ps1" -Lines $lines -ObjectClass $objectClass

})
$searchForm.Controls.Add($searchOKbtn)

$searchCancelBtn=New-Object System.Windows.Forms.Button
$searchCancelBtn.Size=New-Object System.Drawing.Size(75,30)
$searchCancelBtn.Location=New-Object System.Drawing.Size(($searchOKbtn.Location.X-$searchOKbtn.Width-3),($searchForm.Size.Height-80))
$searchCancelBtn.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$searchCancelBtn.Text="&Cancel"
$searchCancelBtn.Add_Click({
    $searchForm.Dispose()
})
$searchForm.Controls.Add($searchCancelBtn)

$classCBox=New-Object System.Windows.Forms.ComboBox
$classCBox.Font=New-Object System.Drawing.Font($myFont,10,[System.Drawing.FontStyle]::Regular)
$classCBox.Size=New-Object System.Drawing.Size(100,100)
$classCBox.Location=New-Object System.Drawing.Size(7,18)
$classCBox.DropDownStyle=2
'User,Group,Computer'.Split(',')|%{$classCBox.Items.Add($_) > $null}
$searchForm.Controls.Add($classCBox)
$classCBox.SelectedIndex=0

$labelBox=New-Object System.Windows.Forms.GroupBox
$labelBox.Text='Object Class'
$labelBox.Font=New-Object System.Drawing.Font($myFont,9,[System.Drawing.FontStyle]::Regular)
$labelBox.Location=New-Object System.Drawing.Size(10,($searchCancelBtn.Location.Y-20))
$labelBox.Size=New-Object System.Drawing.Size(($classCBox.Width+15),($classCBox.Height+26))
$labelBox.Controls.Add($classCBox)
$searchForm.Controls.Add($labelBox)

$searchForm.Add_KeyDown({
    
    if($_.KeyCode -eq 'Escape'){
        $searchForm.Dispose()
    }
})

$searchForm.Add_Shown({$searchForm.Activate()})

$searchForm.ShowDialog() > $null