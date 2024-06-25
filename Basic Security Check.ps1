# Basic Security Check

# Set the log file path
$logFile = "$env:USERPROFILE\Documents\security_check.txt"

# Function to log output
function Log-Output 
{
    param 
    (
        [string]$message
    )

    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp - $message" | Out-File -FilePath $logFile -Append
}

# Log script start
Log-Output "Security check started."

# 1. Check running processes
Log-Output "Checking running processes..."
$processes = Get-Process | Select-Object Name, Id, CPU
$processes | Format-Table -AutoSize | Out-String | Out-File -FilePath $logFile -Append

# 2. Verify critical Windows services are running
Log-Output "Verifying critical Windows services..."
$criticalServices = @("WinDefend", "wuauserv", "EventLog", "Bits")

foreach ($service in $criticalServices) 
{
    $serviceStatus = Get-Service -Name $service

    if ($serviceStatus.Status -ne "Running") 
    {
        Log-Output "Service $service is not running! Status: $($serviceStatus.Status)"
    } 

    else 
    {
        Log-Output "Service $service is running."
    }
}

# 3. Check startup items
Log-Output "Checking startup items..."
$startupItems = Get-CimInstance -ClassName Win32_StartupCommand | Select-Object Name, Command, User
$startupItems | Format-Table -AutoSize | Out-String | Out-File -FilePath $logFile -Append

# 4. Scan for unusual network connections
Log-Output "Scanning for unusual network connections..."
$netstat = netstat -ano | Select-String "ESTABLISHED"
$netstat | Out-File -FilePath $logFile -Append

# Log script end
Log-Output "Security check completed."

# Output completion message
Write-Output "Security check completed. Log file created at $logFile."
