$ErrorActionPreference='Stop'

try{

$depPath="$PSScriptRoot"
$myFont='Helvetica'

ls "$depPath\Functions\*.ps1"|%{. $_.FullName}

. "$depPath\mainUI.ps1"

}catch{

$hash=@{
    Title='Execution Error'
    Message=$_
    Buttons='OK'
    Icon='Error'
}

Show-MessageBox @hash

}