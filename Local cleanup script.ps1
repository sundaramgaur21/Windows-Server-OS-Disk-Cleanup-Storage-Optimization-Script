# Define the cleanup threshold (85%)
$cleanupThreshold = 85

# Define the log file path and name
$logFilePath = "C:\OS Drive Cleanup Logs.txt"

# Function to get disk usage
function Get-DiskUsage {
    $disk = Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'"
    $usage = ($disk.Size - $disk.FreeSpace) / $disk.Size * 100
    return $usage
}

# Function to perform cleanup tasks
function Perform-Cleanup {
    Remove-Item -Path "C:\temp\temp\*" -Recurse -Force
    Remove-Item -Path "C:\windows\temp\temp\*" -Recurse -Force
    Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\temp\*" -Recurse -Force
    Clear-RecycleBin -force
    Remove-Item -Path "C:\Users\*\AppData\Local\Microsoft\Windows\temp\*" -Recurse -Force
    Remove-Item -Path "C:\Windows\SoftwareDistribution\DeliveryOptimization\temp*" -Recurse -Force
    Get-ChildItem -Path C:\Windows\ccmcache -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-90)} | Remove-Item -Force -Recurse
}

# Get initial disk usage
$initialUsage = Get-DiskUsage

# Check if cleanup is needed
if ($initialUsage -gt $cleanupThreshold) {
    # Perform cleanup tasks
    Perform-Cleanup
    
    # Get post-cleanup disk usage
    $postCleanupUsage = Get-DiskUsage
    
    # Log post-cleanup data
    $logEntry = "Post-cleanup disk usage: $($postCleanupUsage)% - $(Get-Date)"
    Add-Content -Path $logFilePath -Value $logEntry
}