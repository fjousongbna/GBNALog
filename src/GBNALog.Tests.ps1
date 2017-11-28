Import-Module -Name GBNAlog

$logFile = "TestDrive:\output.log"

Describe "Test module_log" {
    Context "Tests for Header and Footer" {
        It "Implements the header" {
            Write-GBNALog -Filepath $logFile -Header
            Get-Content $logFile | Select-String -Pattern '^When generated' -Quiet | Should Be $true
        }
        It "Implements the footer" {
            Write-GBNALog -Filepath $logFile -Footer
            Get-Content $logFile | Select-String -Pattern '^End time' -Quiet | Should Be $true
        }
    }
    Context "Implements INFORMATION log in the body" {
        It "Writes an INF entry" {
            Write-GBNALog -Filepath $logFile -Category "INF" -Message "Ligne d'information"
            Get-Content $logFile | Select-String -Pattern 'INF;' -Quiet | Should Be $true
        }
    }
    Context "Implements WARNING log in the body" {
        It "Writes a WAR entry" {
            Write-GBNALog -Filepath $logFile -Category "WAR" -Message "Ligne de warning"
            Get-Content $logFile | Select-String -Pattern 'WAR;' -Quiet | Should Be $true
        }
    }
    Context "Implements ERROR in the body" {
        It "Writes an ERR entry" {
            Write-GBNALog -Filepath $logFile -Category "ERR" -Message "Ligne d'erreur"
            Get-Content $logFile | Select-String -Pattern 'ERR;' -Quiet | Should Be $true
        }
    }
}
