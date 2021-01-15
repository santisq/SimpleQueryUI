function ObjectSearcher{
param(
    [string[]]$Objects,
    [validateSet('User','Group','Computer')]
    [string]$Class,
    [string[]]$Properties
)

$progressLbl.Text='Processing...'
$progressBar.Maximum=$Objects.Count
$progressBar.Value=0
$progressBar.Step=1
$mainForm.Refresh()
#sleep -Milliseconds 1

foreach($Object in $Objects)
{
    $filter="(|(distinguishedname=$Object)(samaccountname=$Object)(name=$Object)(userprincipalname=$Object))"
    switch($Class)
    {
        'User'{Get-ADUser -LDAPFilter $filter -Properties $Properties}
        'Group'{Get-ADGroup -LDAPFilter $filter -Properties $Properties}
        'Computer'{Get-ADComputer -LDAPFilter $filter -Properties $Properties}
    }
    
    $progressBar.PerformStep()
    $mainForm.Refresh()
    sleep -Milliseconds 1
    
}

$progressBar.Value=0

}