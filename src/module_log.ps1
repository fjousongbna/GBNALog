function Write-GBNALog {
    <#
    .SYNOPSIS
        Short description
    .DESCRIPTION
        Long description
    .EXAMPLE
        Example of how to use this cmdlet
    .EXAMPLE
        Another example of how to use this cmdlet
    .INPUTS
        Inputs to this cmdlet (if any)
    .OUTPUTS
        Output from this cmdlet (if any)
    .NOTES
        General notes
    .COMPONENT
        The component this cmdlet belongs to
    .ROLE
        The role this cmdlet belongs to
    .FUNCTIONALITY
        The functionality that best describes this cmdlet
    #>
    [CmdletBinding(SupportsShouldProcess=$true,
                    PositionalBinding=$false,
                    ConfirmImpact='Medium')]
    Param (
        # Filepath help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Alias('Path')]
        [String]$Filepath,
        
        # Category help description
        [Parameter(ParameterSetName='set2',
                    Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Category,
        
        # Message help description
        [Parameter(ParameterSetName='set2',
                    Mandatory=$true,
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [String]$Message,
        
        # Delimiter help description
        [Parameter(ParameterSetName='set2',
                    ValueFromPipeline=$true,
                    ValueFromPipelineByPropertyName=$true)]
        [ValidateNotNullOrEmpty()]
        [Char]$Delimiter = ';',

        # Header help description
        [Parameter(ParameterSetName='set1',
                   Mandatory=$true)]
        [Switch]$Header,

        # Footer help description
        [Parameter(ParameterSetName='set3',
                    Mandatory=$true)]
        [Switch]$Footer,

        # ToScreen help description
        [Parameter()]
        [Switch]$ToScreen,

        # Encoding help description
        [Parameter(ValueFromPipeline=$true,
            ValueFromPipelineByPropertyName=$true)]
        [string]$Encoding = 'Default'
    )
    
    begin {
        Write-Verbose -Message $pscmdlet.ParameterSetName
        $pc = Get-CimInstance Win32_ComputerSystem # -ComputerName $computerName
        $os = Get-CimInstance Win32_OperatingSystem # -ComputerName $computerName
    }
    
    process {
        switch ($pscmdlet.ParameterSetName) { 
            'set1' {
                if ($pscmdlet.ShouldProcess($Filepath, "Write Header")) {
                    $logHeader = "+----------------------------------------------------------------------------------------+" +
                    "`nScript fullname          : {0}" -f $MyInvocation.ScriptName +
                    "`nWhen generated           : {0}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss") +
                    "`nCurrent user             : {0}" -f [System.Security.Principal.WindowsIdentity]::GetCurrent().Name +
                    "`nCurrent computer         : {0}" -f $pc.Name +
                    "`nOperating System         : {0}" -f $os.Caption +
                    "`nOS Architecture          : {0}" -f $os.OSArchitecture +
                    "`n+----------------------------------------------------------------------------------------+"
                    if ($ToScreen) {
                        $logHeader;
                    } else {
                        $logHeader | Out-File -FilePath $Filepath -Encoding $Encoding -Append;
                    }
                }
                break
            }
            'set2' {
                if ($pscmdlet.ShouldProcess($Filepath, "Write Log")) {
                    $logMessage = '{0}{1}{2}{1}{3}' -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"),`
                                                    $Delimiter,`
                                                    $Category,`
                                                    $Message;
                    if ($ToScreen) {
                        switch ($Category) { 
                            "INF" {Write-Host $logMessage -ForegroundColor Cyan; break}
                            "WAR" {Write-Host $logMessage -ForegroundColor Yellow; break}
                            "ERR" {Write-Host $logMessage -ForegroundColor Red; break}
                        }
                    } else {
                        $logMessage | Out-File -FilePath $Filepath -Encoding $Encoding -Append;
                    }
                }
                break
            }
            'set3' {
                if ($pscmdlet.ShouldProcess($Filepath, "Write Footer")) {
                    $lineGenerated = Select-String -Path $FilePath -Pattern "^(.*)(When generated)\s*:\s*(.*)" -AllMatches
                    $dumb = $lineGenerated -match '^(.*)(When generated)\s*:\s*(.*)'
                    $dateStart = Get-Date -Date $Matches[3]
                    $dateEnd = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
                    $logFooter = "+----------------------------------------------------------------------------------------+"+
                    "`nEnd time                 : {0}" -f $dateEnd +
                    "`nTotal duration (seconds) : {0}" -f (New-TimeSpan -Start ($dateStart) -End ($dateEnd)).TotalSeconds +
                    "`nTotal duration (minutes) : {0:0}" -f (New-TimeSpan -Start ($dateStart) -End ($dateEnd)).TotalMinutes +
                    "`n+----------------------------------------------------------------------------------------+"
                    if ($ToScreen) {
                        $logFooter;
                    } else {
                        $logFooter | Out-File -FilePath $Filepath -Encoding $Encoding -Append;
                    }
                }
            }
        }
    }
    
    end {
    }
}