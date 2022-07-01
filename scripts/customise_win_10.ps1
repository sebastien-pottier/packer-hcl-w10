$ProgressPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

#Start-Transcript C:\customise.txt

try {
    # Disable password expiration for your local admin account.
    Write-Host "Setting admin account to not expire..."
    wmic useraccount where "name='ansible'" set PasswordExpires=FALSE

    # Set power plan to High Performance.
    Write-Host "Setting power plan to high performance..."
    $p = Get-CimInstance -Name root\cimv2\power -Class win32_PowerPlan | Where-Object {$_.ElementName -like "Performances*"}
    powercfg /setactive ([string]$p.InstanceID).Replace("Microsoft:PowerPlan\{","").Replace("}","")

    # Show file extensions in Windows Explorer.
    Write-Host "Enbaling file extensions in Windows Explorer..."
    Set-Itemproperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0 -Verbose

    ##### While the step below I had to do previously, this breaks now since an application is now required. For some reason, running it manually works. 
    ##### Regardless, it seems I no longer need to remove AppxPackages in order for sysprep to work. 
    # Remove AppxPackages. Windows store applications breaks sysprep. 
    #Get-AppxPackage | Remove-AppxPackage
}
catch {
    Write-Host
    Write-Host "Something went wrong:" 
    Write-Host ($PSItem.Exception.Message)
    Write-Host

    # Sleep for 60 minutes so you can see the errors before the VM is destroyed by Packer.
    Start-Sleep -Seconds 3600

    Exit 1
}

Start-Sleep -Seconds 10
