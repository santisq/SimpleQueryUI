function Show-MessageBox {  
    [CmdletBinding()]  
    Param (   
        [Parameter(Mandatory = $false)]  
        [string]$Title,
        [Parameter(Mandatory = $true)]
        [string]$Message,  
        [Parameter(Mandatory = $false)]
        [ValidateSet('OK', 'OKCancel', 'AbortRetryIgnore', 'YesNoCancel', 'YesNo', 'RetryCancel')]
        [string]$Buttons,
        [Parameter(Mandatory = $false)]
        [ValidateSet('Error', 'Warning', 'Information', 'None', 'Question')]
        [string]$Icon,
        [Parameter(Mandatory = $false)]
        [ValidateRange(1,3)]
        [int]$DefaultButton = 1
    )            

    # determine the possible default button
    if ($Buttons -eq 'OK') {
        $Default = 'Button1'
    }
    elseif (@('AbortRetryIgnore', 'YesNoCancel') -contains $Buttons) {
        $Default = 'Button{0}' -f [math]::Max([math]::Min($DefaultButton, 3), 1)
    }
    else {
        $Default = 'Button{0}' -f [math]::Max([math]::Min($DefaultButton, 2), 1)
    }

    # Setting the first parameter 'owner' to $null lets the messagebox become topmost
    [System.Windows.Forms.MessageBox]::Show($null, $Message, $Title,   
                                            [Windows.Forms.MessageBoxButtons]::$Buttons,   
                                            [Windows.Forms.MessageBoxIcon]::$Icon,
                                            [Windows.Forms.MessageBoxDefaultButton]::$Default)
}