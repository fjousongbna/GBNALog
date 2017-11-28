Set-StrictMode -Version 2
#Set-PSDebug -Step

function ConvertFrom-Log {
    [CmdletBinding(SupportsShouldProcess=$true,
                   PositionalBinding=$false,
                   ConfirmImpact='Medium')]
    Param (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipeline=$true,
                   ValueFromPipelineByPropertyName=$true,
                   ParameterSetName='set1')]
        [ValidateNotNullOrEmpty()]
        $Filepath
   )
    
    begin {
    }
    
    process {
        if ($pscmdlet.ShouldProcess("Target", "Operation")) {}
        $logFile = [LogFile]::new()

        foreach ($line in Get-Content -Path $FilePath) {
            if ($line -match '^(\d.{18})(.)(.{3})(.)(.*)') {
                $logEntry = [LogEntry]::new($Matches[1], $Matches[3], $Matches[5])
                $logFile.Logs += $LogEntry
            }
        }
#Set-PSDebug -Step
    }
    
    end {
        $logFile
    }
}
#Set-PSDebug -Off
