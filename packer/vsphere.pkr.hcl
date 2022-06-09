packer {
  required_version = ">= 1.7.4"

  required_plugins {
    windows-update = {
      version = "0.14.0"
      source = "github.com/rgl/windows-update"
      # Github Plugin Repo https://github.com/rgl/packer-plugin-windows-update
    }
  }
}

source "vsphere-iso" "win_10_sysprep" {

  # Connection Configuration
  insecure_connection     = true
  vcenter_server          = var.vcenter_server
  username                = var.vcenter_username
  password                = var.vcenter_password

  # Location Configuration
  cluster                 = var.vcenter_cluster
  datacenter              = var.vcenter_datacenter
  host                    = var.vcenter_host
  datastore               = var.vcenter_datastore
  folder                  = var.vcenter_folder

    notes                   = "Windows 10 Pro x64 VM template built using Packer.\nThis template is syspred and can be used for domain deployments."

  # Communicator configuration
  ip_wait_timeout         = "20m"
  ip_settle_timeout       = "1m"
  communicator            = "winrm"
  #winrm_port             = "5985"
  winrm_timeout           = "10m"
  pause_before_connecting = "5m"
  winrm_username          = var.os_username
  winrm_password          = var.os_password_workstation

  # Hardware Configuration
  vm_name                 = "${var.vm_name}_${formatdate ("YYYY_MM", timestamp())}"
  vm_version              = var.vm_version
  firmware                = var.vm_firmware
  guest_os_type           = var.vm_guest_os_type
  CPUs                    = var.cpu_num
  CPU_hot_plug            = true
  RAM                     = var.ram
  RAM_reserve_all         = false
  RAM_hot_plug            = true
  video_ram               = "16384"
  cdrom_type              = "sata"
  disk_controller_type    = ["lsilogic-sas"]
    
  network_adapters {
    network               = var.vm_network
    network_card          = var.network_card
  }
  
   storage {
    disk_thin_provisioned = true
    disk_size             = var.disk_size
  }

  # ISO Configuration
  iso_paths = [
    var.os_iso_path,
    var.vmtools_iso_path
  ]

  floppy_dirs = ["scripts",]
  floppy_files = ["unattended/autounattend.xml"]

  # Boot Configuration
  boot_wait    = "3s"
  boot_command = [
    "<spacebar><spacebar>"
  ]

  # Content Library Import Configuration
  convert_to_template     = false
  content_library_destination {
    library              = "Templates"
    ovf                  = true
  }
}

build {
  /* 
  Note that provisioner "Windows-Update" performs Windows updates and reboots where necessary.
  Run the update provisioner as many times as you need. I found that 3-to-4 runs tended,
  to be enough to install all available Windows updates. Do check yourself though!
  */

  sources = ["source.vsphere-iso.win_10_sysprep"]

  provisioner "windows-restart" { # A restart to settle Windows prior to updates
    pause_before    = "2m"
    restart_timeout = "15m"
  }

/* commente pendant le dev (trop long)
  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      #"exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
      "exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
  }

  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      #"exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
      "exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
  }

  provisioner "windows-update" {
    pause_before = "2m"
    timeout = "1h"
    search_criteria = "IsInstalled=0"
    filters = [
      #"exclude:$_.Title -like '*VMware*'", # Can break winRM connectivity to Packer since driver installs interrupt network connectivity
      "exclude:$_.Title -like '*Preview*'",
      "include:$true"
    ]
  }
  */

  provisioner "powershell" {
    pause_before      = "2m"
    elevated_user     = var.os_username
    elevated_password = var.os_password_workstation
    script            = "scripts/customise_win_10.ps1"
    timeout           = "15m"
  }

  provisioner "windows-restart" { # A restart before sysprep to settle the VM once more.
    pause_before    = "2m"
    restart_timeout = "1h"
  }

  provisioner "powershell" {
    pause_before      = "2m"
    elevated_user     = var.os_username
    elevated_password = var.os_password_workstation
    script            = "scripts/sysprep_win_10.ps1"
    timeout           = "15m"
  }
}