# A Packer config that works with this configuration would be:
#    "winrm_insecure": true,
#    "winrm_use_ssl": true

$ErrorActionPreference = "SilentlyContinue"
$ErrorActionPreference = "Stop"

#Start-Transcript C:\configure_winrm.txt

try{
    Set-ExecutionPolicy Unrestricted -Scope LocalMachine -Force -ErrorAction Ignore

    # Set network profile to PRIVATE. Required since the WinRM config 
    # below will error out if a network profile is set to PUBLIC. 
    Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private

    # Remove HTTP listener
    Remove-Item -Path WSMan:\Localhost\listener\listener* -Recurse

    # Create a self-signed certificate to let ssl work
    $Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName $env:COMPUTERNAME
    New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint -Force

    # WinRM
    write-output "Setting up WinRM"
    write-host "(host) setting up WinRM"

    # Configure WinRM to allow unencrypted communication, and provide the
    # self-signed cert to the WinRM listener.
    cmd.exe /c winrm quickconfig -q
    cmd.exe /c winrm set "winrm/config/service" '@{AllowUnencrypted="true"}'
    cmd.exe /c winrm set "winrm/config/client" '@{AllowUnencrypted="true"}'
    cmd.exe /c winrm set "winrm/config/service/auth" '@{Basic="true"}'
    cmd.exe /c winrm set "winrm/config/client/auth" '@{Basic="true"}'
    cmd.exe /c winrm set "winrm/config/service/auth" '@{CredSSP="true"}'
    cmd.exe /c winrm set "winrm/config/listener?Address=*+Transport=HTTPS" "@{Port=`"5986`";Hostname=`"$env:COMPUTERNAME`";CertificateThumbprint=`"$($Cert.Thumbprint)`"}"

    # Make sure appropriate firewall port openings exist
    cmd.exe /c netsh advfirewall firewall set rule group="Gestion à distance de Windows" new enable=yes
    cmd.exe /c netsh advfirewall firewall add rule name= "Port 5986" dir=in action=allow protocol=TCP localport=5986

    # Restart WinRM, and set it so that it auto-launches on startup.
    cmd.exe /c net stop winrm
    cmd.exe /c sc config winrm start= auto
    cmd.exe /c net start winrm
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
