enum LogCategory {
    INF
    WAR
    ERR
}

class LogEntry {
    # Properties
    [datetime] $DateEntry
    [LogCategory] $Category
    [string] $Message

    # Constructors: LogEntry
    LogEntry() {}

    LogEntry([datetime] $DateEntry, [LogCategory] $Category, [String] $Message) {
        $this.DateEntry = $DateEntry
        $this.Category  = $Category
        $this.Message   = $Message
    }
}

class Header {
    # Properties
    [string] $FullScriptName
    [datetime] $WhenGenerated
    [string] $CurrentUser
    [string] $CurrentComputer
    [string] $OS
    [string] $OSArchitecture
    # Constructors: Header
    Header() {}

    Header([string] $FullScriptName, [datetime] $WhenGenerated, [string] $CurrentUser, [string] $CurrentComputer, [string] $OS, [string] $OSArchitecture) {
        $this.FullScriptName    = $FullScriptName
        $this.WhenGenerated     = $WhenGenerated
        $this.CurrentUser       = $CurrentUser
        $this.CurrentComputer   = $CurrentComputer
        $this.$OS               = $OS
        $this.OSArchitecture    = $OSArchitecture
    }
}

class Footer {
    # Properties
    [datetime] $Endtime
    [int] $TotalDurationSeconds
    [int] $TotalDurationMinutes

    # Constructors: Footer
    Footer() {}

    Footer([datetime] $Endtime, [int] $TotalDurationSeconds, [int] $TotalDurationMinutes) {
        $this.Endtime               = $Endtime
        $this.TotalDurationSeconds  = $TotalDurationSeconds
        $this.TotalDurationMinutes  = $TotalDurationMinutes
    }
}

class LogFile {
    # Properties
    [Header] $Header
    [LogEntry[]] $Logs
    [Footer] $Footer

    LogFile() {}
}