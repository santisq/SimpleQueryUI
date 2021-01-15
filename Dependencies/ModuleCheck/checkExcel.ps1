$errMsg="This program requires the ImportExcel v7.1.0 PowerShell Module.

Click 'Yes' to be redirected to Powershell Gallery website where you can find installation instructions or click 'No' to choose a different export format."

$resetBar={
    $progressBar.Value=0
    $progressBar.Style=1
    $progressLbl.Text='Ready'
    $mainForm.Refresh()
}

try{

    if((Get-Module ImportExcel).Version.Major -ne 7){
        
        $progressLbl.Text='Loading Excel Module...'
        $progressBar.Maximum=100
        $mainForm.Refresh()
        sleep -Milliseconds 1
        while($progressBar.Value -lt $progressBar.Maximum/2)
        {
            $progressBar.Value++
            $mainForm.Refresh()
            sleep -Milliseconds 1
        }

        $ExcelTrue=Import-Module ImportExcel -PassThru

        $mainForm.Refresh()
        $progressBar.Value=100
        $mainForm.Refresh()
        sleep -Milliseconds 5

        &$resetBar

        if($ExcelTrue.Version.Major -ne 7){throw}
        else{return $True}
        
    }else{return $true}

}catch{

    $hash=@{
        Title='Dependency Module Error'
        Message=$errMsg
        Buttons='YesNo'
        Icon='Warning'
    }
    $result=Show-MessageBox @hash
    if($result -eq 'Yes')
    {        
        start-process 'https://www.powershellgallery.com/packages/ImportExcel/7.0.1'
        &$resetBar
        break

    }else{
            
        &$resetBar
        break    
    }

}