#PowerShell Script to Display System Information

#Function to get the system information
function Get-SystemInfo 
{
    $systemInfo = @{}

    Write-Host "Fetching OS information..." -ForegroundColor Cyan
    # Get OS information
    $os = Get-CimInstance -ClassName Win32_OperatingSystem
    if ($os) 
    {
        $systemInfo["Operating System"] = $os.Caption
        $systemInfo["OS Version"] = $os.Version
        $systemInfo["OS Architecture"] = $os.OSArchitecture
    } 

    else 
    {
        Write-Host "Failed to fetch OS information" -ForegroundColor Red
    }

    Write-Host "Fetching computer system information..." -ForegroundColor Cyan
    # Get computer system information
    $cs = Get-CimInstance -ClassName Win32_ComputerSystem
    if ($cs) 
    {
        $systemInfo["Computer Name"] = $cs.Name
        $systemInfo["Manufacturer"] = $cs.Manufacturer
        $systemInfo["Model"] = $cs.Model
        $systemInfo["Total Physical Memory (GB)"] = [math]::Round($cs.TotalPhysicalMemory / 1GB, 2)
    } 

    else 
    {
        Write-Host "Failed to fetch computer system information" -ForegroundColor Red
    }

    Write-Host "Fetching processor information..." -ForegroundColor Cyan
    # Get processor information
    $cpu = Get-CimInstance -ClassName Win32_Processor
    if ($cpu) 
    {
        $systemInfo["Processor"] = $cpu.Name
        $systemInfo["Processor Cores"] = $cpu.NumberOfCores
        $systemInfo["Logical Processors"] = $cpu.NumberOfLogicalProcessors
    } 
    
    else 
    {
        Write-Host "Failed to fetch processor information" -ForegroundColor Red
    }

    Write-Host "Fetching graphics card information..." -ForegroundColor Cyan
    #Get graphics card information
    $gpu = Get-CimInstance -ClassName Win32_VideoController
    $gpuDetails = $gpu | Select-Object -First 1
    if ($gpuDetails) 
    {
        $systemInfo["Graphics Card"] = $gpuDetails.Name
    } 
    
    else 
    {
        Write-Host "Failed to fetch graphics card information" -ForegroundColor Red
    }

    Write-Host "Fetching disk information..." -ForegroundColor Cyan
    #Get disk information
    $disk = Get-CimInstance -ClassName Win32_DiskDrive | Select-Object -First 1
    if ($disk) {
        $systemInfo["Disk Model"] = $disk.Model
        $systemInfo["Disk Size (GB)"] = [math]::Round($disk.Size / 1GB, 2)
    } 
    
    else 
    {
        Write-Host "Failed to fetch disk information" -ForegroundColor Red
    }

    Write-Host "Fetching serial number..." -ForegroundColor Cyan
    #Get serial number
    $bios = Get-CimInstance -ClassName Win32_BIOS
    if ($bios) 
    {
        $systemInfo["Serial Number"] = $bios.SerialNumber
    } 

    else 
    {
        Write-Host "Failed to fetch serial number" -ForegroundColor Red
    }

    return $systemInfo
}

#Get and display system information
try 
{
    $info = Get-SystemInfo
    Write-Host "System Information:" -ForegroundColor Green
    
    if ($info.Count -eq 0) 
    {
        Write-Host "No information retrieved" -ForegroundColor Red
    } 

    else 
    {
        $info.GetEnumerator() | ForEach-Object { Write-Host "$($_.Key): $($_.Value)" -ForegroundColor Yellow }
    }
} 

catch 
{
    Write-Host "An error occurred: $_" -ForegroundColor Red
}
