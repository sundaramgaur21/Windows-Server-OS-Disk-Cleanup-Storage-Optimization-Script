Add-Type -AssemblyName System.Windows.Forms
$FileDialog = New-Object System.Windows.Forms.OpenFileDialog
$FileDialog.Filter = "Text Files (*.txt)|*.txt"
$FileDialog.Title = "Select server list file"
$null = $FileDialog.ShowDialog()
$ServerListFile = $FileDialog.FileName
$servers = Get-Content -Path $ServerListFile
$Output = @()

Foreach ($Server in $Servers) {
    Write-Host "Processing server : $Server"
    $diskbefore = Invoke-Command -ComputerName $Server -ScriptBlock { Get-WmiObject -Class Win32_LogicalDisk -Filter "DeviceID='C:'" }
    Invoke-Command -ComputerName $Server -ScriptBlock { Remove-Item -Path "C:\temp\temp\*" -Recurse -Force }
    Invoke-Command -ComputerName $Server -ScriptBlock { Remove-Item -Path "C:\windows\temp\temp\*" -Recurse -Force }
    Invoke-Command -ComputerName $Server -ScriptBlock { Remove-Item -Path "C:\Windows\SoftwareDistribution\Download\temp\*" -Recurse -Force }
    Invoke-Command -ComputerName $Server -ScriptBlock { Clear-RecycleBin -force }
    Invoke-Command -ComputerName $Server -ScriptBlock { Remove-Item -Path "C:\Users\*\AppData\Local\Microsoft\Windows\temp\*" -Recurse -Force }
    Invoke-Command -ComputerName $Server -ScriptBlock { Remove-Item -Path "C:\Windows\SoftwareDistribution\DeliveryOptimization\temp*" -Recurse -Force }
    Invoke-Command -ComputerName $Server -ScriptBlock { Get-ChildItem -Path C:\Windows\ccmcache -Recurse | Where-Object {$_.LastWriteTime -lt (Get-Date).AddDays(-90)) } | Remove-Item -Force -Recurse }
    $diskafter = Invoke-Command -ComputerName $Server -ScriptBlock {Get-WmiObject -class Win32_logicalDisk -Filter "DeviceID='C:'"}
    $Obj = [PSCustomObject]@{
        SerialNumber = ($Output.Count + 1)
        Servername = $Server
        TotalCDriveSize = "{0:N2} GB" -f ($diskbefore.Size / 1GB)
        CDriveFreeSpaceBefore = "{0:N2} GB" -f ($diskbefore.FreeSpace / 1GB)
        UtilizedCDrivespacebefore = "{0:N2} GB" -f (($diskbefore.Size - $diskbefore.FreeSpace) / 1GB)
        CDrivePercentageFreeBefore = "{0:N2} %" -f (($diskbefore.FreeSpace / $diskbefore.Size) * 100)
        CDriveFreeSpaceAfter = "{0:N2} GB" -f ($diskafter.FreeSpace / 1GB)
        UtilizedCDrivespaceAfter = "{0:N2} GB" -f (($diskafter.Size - $diskafter.FreeSpace) / 1GB)
        CDrivePercentageFreeAfter = "{0:N2} %" -f (($diskafter.FreeSpace / $diskafter.Size) * 100)
    }
    $Output += $Obj
}
$Output | Export-Csv -Path "C:\temp\cleanup_output.csv" -NoTypeInformation