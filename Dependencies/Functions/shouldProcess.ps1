function shouldProcess{
[cmdletbinding()]
param(
    [string[]]$Entries,
    [validateSet('User','Group','Computer')]
    [string]$Class
)

begin{

$progressLbl.Text='Validating entries...'
$progressBar.Maximum=$Entries.Count
$progressBar.Step=1
$mainForm.Refresh()

$domain=(Get-ADRootDSE).DefaultNamingContext
$culture=(Get-Culture).TextInfo

}

process{

foreach($entry in $Entries)
{
    $filter="(|(distinguishedname=$entry)(samaccountname=$entry)(name=$entry)(a-personnelNumber=$entry)(a-nonAccentureNumber=$entry)(userprincipalname=$entry))"
    $obj=Get-ADObject -LDAPFilter $filter|select -First 1
    
    switch($obj.ObjectClass){
        {$_ -eq $Class}{continue}
        {$_ -and $_ -ne $Class}{
         
            $objClass=$culture.ToTitleCase($_)
            $shouldClass=$culture.ToTitleCase($class)

            [pscustomobject]@{
                Entry=$entry
                Status="Object Class is '$objClass'. Selected Class for query was: '$shouldClass'."
            }
        }
        Default{
            
            [pscustomobject]@{
                Entry=$entry
                Status="Cannot find an object with identity: '$entry' under: $domain"
            }
        }
    }

    $progressBar.PerformStep()
    $mainForm.Refresh()
    sleep -Milliseconds 1
}

}

}