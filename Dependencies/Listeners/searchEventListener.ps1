param(
    [parameter(mandatory)]
    [string[]]$Lines,
    [parameter(mandatory)]
    [string]$ObjectClass
)

$culture=(Get-Culture).TextInfo

if($lines)
{
    $shouldProcess=shouldProcess -Entries $lines -Class $objectClass
    if($shouldProcess){
        . "$depPath\Forms\skippedForm.ps1" -SkippedLines $shouldProcess
        $script:toProcess=$lines|?{$_ -notin $shouldProcess.Entry}
    }else{
        $script:toProcess=$lines
    }
}
if($toprocess)
{
    $i=$toProcess|select -First 1
    $filter="(|(distinguishedname=$i)(samaccountname=$i)(name=$i)(a-personnelNumber=$i)(a-nonAccentureNumber=$i)(userprincipalname=$i))"
    $allProps=switch($objectClass)
    {
        'User'{
            Get-ADUser -LDAPFilter $filter -Properties *
        }
        'Group'{
            Get-ADGroup -LDAPFilter $filter -Properties *
        }
        'Computer'{
            Get-ADComputer -LDAPFilter $filter -Properties *
                
        }
    }
    
    $progressBar.PerformStep()

    if($allProps)
    {
        $script:propsArray=($allProps|gm -MemberType Property).Name|?{$_ -notmatch 'PSShowComputerName|Write'}
        . "$depPath\Forms\propsForm.ps1" -Properties $propsArray -toProcess $toProcess -ObjectClass $objectClass
        $searchForm.Dispose()
    }
}
else
{
$msg='None of the entries used could be found in Active Directory.
Check your input and try again.'

   $hash=@{
        Title='No Objects Found'
        Message=$msg
        Buttons='OK'
        Icon='Information'
    }
    $result=Show-MessageBox @hash

$progressBar.Value=0
$progressLbl.Text='Ready'
}