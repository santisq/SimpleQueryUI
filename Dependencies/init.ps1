try
{
    $depPath="$PSScriptRoot"
    $myFont='Helvetica' #'Microsoft Sans Serif'
    ls "$depPath\Functions\*.ps1"|%{. $_.FullName}

    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    Add-Type -AssemblyName PresentationFramework
    Add-Type -Path "$depPath\Assembly\DPI Awareness.cs" -ReferencedAssemblies System.Drawing.dll
    [System.Windows.Forms.Application]::EnableVisualStyles()

    $DPI=[Math]::round([DPI]::scaling(), 2) * 100
    $Size=[System.Windows.Forms.SystemInformation]::PrimaryMonitorSize
    $width=($Size.Width / 100) * $DPI
    $height=($Size.Height / 100) * $DPI

    $ErrorActionPreference='Stop'

    . "$depPath\mainUI.ps1"

}
catch
{
    $hash=@{
        Title='Execution Error'
        Message=$_
        Buttons='OK'
        Icon='Error'
    }

    Show-MessageBox @hash
}