$logPath = "C:\Windows\logs\Software\PermanentAdmin.log"
function Write-log{
    param([string]$message)
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp : $message"
    Add-Content -Path $logPath -Value $logMessage
}

Write-log "PermanentAdmin Script execution started"
function Remove-DisconnectedSessions {
    Write-log "Checking and removing disconnected sessions"
    $sessions = query user
    foreach ($session in $sessions) {    
        $sessionDetails = $session -split '\s+'
       
        if ($sessionDetails[3] -eq 'Disc') {
            $sessionId = $sessionDetails[2]

            logoff $sessionId
            Write-log "Logged off disconnected session: $sessionId"
            
        }
    }
}

Remove-DisconnectedSessions

Write-log "Checking Current user"
function Get-CurrentUser {
    $explorerProcesses = Get-WmiObject Win32_Process -Filter "Name='explorer.exe'"
    $loggedOnUsers = @()   
    foreach ($process in $explorerProcesses) {
        $user = $process.GetOwner().User
        $loggedOnUsers += $user
    }
    $distinctUsers = $loggedOnUsers | Select-Object -Unique
    return $distinctUsers
    Write-log "Current user identified as: $distinctUsers"
}


function Add-UserToAdmins {
    param (
        [string]$username

    )

    if ((Get-Service -Name GroupMgmtSvc -ErrorAction SilentlyContinue).status -eq "Running" ) { 
    Write-log "Stopping GroupMgmtSvc Service " 
    Set-Service -Name GroupMgmtSvc -StartupType Disabled -Status Stopped -ErrorAction SilentlyContinue
    Get-Service -Name GroupMgmtSvc | Stop-Service -Force -ErrorAction SilentlyContinue
    Write-log "Stopped and GroupMgmtSvc Service" 
    }
    else
    {
    Write-log "GroupMgmtSvc Service is not Running" 
    }

    if ((Get-Service -Name GroupMgmtSvc -ErrorAction SilentlyContinue).status -eq "Stopped" ){
    try {
        Add-LocalGroupMember -SID S-1-5-32-544 -Member $username -ErrorAction Stop
        Write-log "Successfully added $username to local admin group"
        } 
    catch {
    Write-log "Failed to add $username to local admin group. Error: $_"
            }
      }
      Write-log "PerManentAdmin Script completed"

}


$currentUser = Get-CurrentUser
if ($currentUser) {
    
    Add-UserToAdmins -username $currentUser

    } 
     