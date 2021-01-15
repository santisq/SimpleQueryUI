$errMsg="This program requires the Active Directory PowerShell Module.

Click 'Yes' to be redirected to Microsoft website where you can find installation instructions or click 'No' to Exit."

try
{
    if(!(Get-Module ActiveDirectory))
    {
        $progressLbl.Text='Loading Active Directory Module...'
        $progressBar.Maximum=100
        $mainForm.Refresh()
        sleep -Milliseconds 1
        while($progressBar.Value -lt $progressBar.Maximum/2)
        {
            $progressBar.Value++
            $mainForm.Refresh()
            sleep -Milliseconds 1
        }
            
        $ADTrue=Import-Module ActiveDirectory -PassThru
        
        $mainForm.Refresh()
        $progressBar.Value=100
        $mainForm.Refresh()
        sleep -Milliseconds 5
            
        $progressBar.Value=0
        $progressBar.Style=1
        $progressLbl.Text='Ready'
        $mainForm.Refresh()

        if($ADTrue){return $true}
        else{throw}
    
    }else{return $true}

}catch{

    $hash=@{
        Title='Dependency Module Error'
        Message=$errMsg
        Buttons='YesNo'
        Icon='Warning'
    }
    $result=Show-MessageBox @hash
    if($result -eq 'Yes'){
        start-process 'https://docs.microsoft.com/en-us/powershell/module/addsadministration'
    }else{
        $mainForm.Close()
    }

}