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
        $toProcess=$lines|?{$_ -notin $shouldProcess.Entry}
    }else{
        $toProcess=$lines
    }
    $i=$toProcess|select -First 1
    $filter="(|(distinguishedname=$i)(samaccountname=$i)(name=$i)(userprincipalname=$i))"
    $allProps=switch($objectClass)
    {
        'User'{Get-ADUser -LDAPFilter $filter -Properties *}
        'Group'{Get-ADGroup -LDAPFilter $filter -Properties *}
        'Computer'{Get-ADComputer -LDAPFilter $filter -Properties *}
    }
    
    $progressBar.PerformStep()

    if($allProps)
    {
        $propsArray=($allProps|gm -MemberType Property).Name|?{$_ -notmatch 'PSShowComputerName|Write'}
        . "$depPath\Forms\propsForm.ps1" -Properties $propsArray -toProcess $toProcess -ObjectClass $objectClass
        $searchForm.Dispose()
    }

}