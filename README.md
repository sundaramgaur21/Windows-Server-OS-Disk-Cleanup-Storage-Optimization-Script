Overview
------------
The Windows Server Disk Cleanup & Storage Optimization Script is designed to help administrators reclaim disk space across multiple Windows servers from a centralized workstation.
The script reads a list of target servers, performs several cleanup operations remotely, captures disk utilization before and after cleanup, and generates a detailed CSV report showing the storage savings achieved on each server.
This tool is especially useful for:

Low disk space remediation
Server maintenance activities
Monthly housekeeping tasks
SCCM cache cleanup
Patch management cleanup
Infrastructure optimization initiatives
Capacity management reporting


Features
---------
✅ Graphical file picker for server list selection
✅ Batch processing of multiple Windows servers
✅ C: drive utilization analysis before cleanup
✅ Temporary file cleanup
✅ Windows Temp folder cleanup
✅ User Temp folder cleanup
✅ Software Distribution cache cleanup
✅ Delivery Optimization cache cleanup
✅ SCCM Cache cleanup (older than 90 days)
✅ Recycle Bin cleanup
✅ Before-and-after disk utilization reporting
✅ CSV report generation
✅ Consolidated storage savings report

Cleanup Operations Performed
----------------------------
The script performs the following cleanup activities on each server:

Temporary Folder Cleanup
---------------------------
Removes files from:
Plain TextC:\Temp\Temp\
and
Plain TextC:\Windows\Temp\Temp\

Windows Update Download Cache Cleanup
Removes files from:
Plain TextC:\Windows\SoftwareDistribution\Download\

Delivery Optimization Cache Cleanup
Removes files from:
Plain TextC:\Windows\SoftwareDistribution\DeliveryOptimization\

User Temporary Files Cleanup
Removes temporary files from all user profiles:
Plain TextC:\Users\*\AppData\Local\Microsoft\Windows\Temp\

Recycle Bin Cleanup
Clears the Recycle Bin using:
PowerShellClear-RecycleBin -Force

SCCM Cache Cleanup
Removes SCCM cache content older than 90 days:
Plain TextC:\Windows\CCMCache
Files older than:
Plain Text90 Days
are removed automatically.

Prerequisites
---------------
Administrator Permissions
Run PowerShell as Administrator.
The executing account must have administrative permissions on all target servers.

PowerShell Remoting Enabled
Target servers must support PowerShell Remoting.
Enable it using:
PowerShellEnable-PSRemoting -Force

Network Connectivity
The machine executing the script must be able to:

Reach the target servers
Resolve hostnames through DNS
Connect using WinRM


Sufficient Permissions
The executing account must have permission to:

Remove files and folders
Access system directories
Access user profiles
Query disk statistics


Server List Format
Create a text file containing one server name per line.
Example:
Plain TextSERVER01SERVER02SERVER03SERVER04
Save as:
Plain TextServers.txt

How It Works
-------------
Step 1 – Select Server List
When launched, the script opens a file browser.
Select the .txt file containing your server names.

Step 2 – Capture Pre-Cleanup Statistics
The script retrieves C: drive information for each server:

Total Disk Size
Free Space
Used Space
Percentage Free

Example:
Plain TextC Drive Size: 200 GBFree Space: 35 GBUsed Space: 165 GBFree Percentage: 17.5%Show more lines

Step 3 – Execute Cleanup Operations
The script remotely removes temporary files, cache files, recycle bin content, and old SCCM cache data.

Step 4 – Capture Post-Cleanup Statistics
The script rechecks the C: drive and calculates:

Free space after cleanup
Used space after cleanup
Percentage free after cleanup


Step 5 – Generate Report
Results are exported to:
Plain TextC:\Temp\cleanup_output.csv

Sample Output Report

Server      Free Space Before    Free Space After    % Free Before    % Free After
SERVER01    25.50 GB              42.75 GB            12.75%          21.38%
SERVER02    31.10 GB              45.60 GB            15.55%          22.80%

CSV Columns Generated
------------------------
The report includes:
SerialNumber
Servername
TotalCDriveSize
CDriveFreeSpaceBefore
UtilizedCDrivespacebeforeC
DrivePercentageFreeBefore
CDriveFreeSpaceAfter
UtilizedCDrivespace
AfterCDrivePercentage
FreeAfterShow more lines

Usage
------
Clone Repository
PowerShellgit clone https://github.com/sundaramgaur21/Windows-Server-Disk-Cleanup-Tool.git
Run Script
PowerShell.\DiskCleanup.ps1
Select Server List
Choose your text file containing server names.
Review Results
Once completed, open:
Plain TextC:\Temp\cleanup_output.csv
to review reclaimed disk space across all servers.

Example Use Case
----------------
An infrastructure team identifies 50 Windows servers with low C: drive space.
Using this script:

Export affected servers to a text file.
Run the cleanup script.
Perform automated cleanup on all servers.
Generate a CSV report.
Review storage reclaimed.
Identify servers requiring additional remediation.


Benefits
---------
Reduces manual cleanup effort
Reclaims valuable disk space
Improves patching readiness
Reduces SCCM cache bloat
Improves server health
Provides auditable reporting
Supports proactive capacity management


Limitations
-----------
Requires PowerShell Remoting.
Assumes cleanup paths exist on target servers.
Does not currently log failed cleanup actions.
Does not calculate total space reclaimed across all servers.
Does not support parallel execution.
Does not include email reporting.


Future Enhancements
-------------------
Potential improvements include:

HTML reporting
Excel report generation
Email summaries
Parallel processing
Enhanced error handling
Logging framework
Disk space threshold alerts
Automatic scheduling support
Space reclaimed calculations
Before/after charts

Author
------
Sundaram Gaur
Senior Systems Engineer | Windows Server | PowerShell Automation | Infrastructure Operations

Disclaimer
-----------
This script performs file and cache deletion operations on remote Windows servers. Review all cleanup paths carefully and test in a non-production environment before large-scale deployment. Ensure appropriate change approvals are obtained before executing in production environments.
