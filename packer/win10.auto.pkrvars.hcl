/* 
Specify any declared variables from the file of, variables.pkr.hcl, to override default values.
Example of default value of var cpu_name is 2 cores. We override that with 4 cores below.
*/

vcenter_username        = "administrator@vsphere.local"
vcenter_password        = "Rootroot123+"

os_username             = "ansible"
os_password_workstation = "P@ssw0rd!"

/*
Defined in PKR_VAR_xx variables
vcenter_server          = "vcenter.intranet.pottier.eu"
vcenter_cluster         = "Cluster"
vcenter_datacenter      = "Datacenter"
vcenter_host            = "esx1.intranet.pottier.eu"
vcenter_datastore       = "DS-nas-1"
vcenter_folder          = "packer-templates/win"

vm_name                 = "win10_pro_x64_packer_template"
vm_network              = "VM Network"
vm_guest_os_type        = "windows9_64Guest" # Refer to https://code.vmware.com/apis/704/vsphere/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html for guest OS types.
vm_version              = "19" # Refer to https://kb.vmware.com/s/article/1003746 for specific VM versions.

os_iso_path             = "[DS-ISO] windows_10_x64_21H2.iso"
vmtools_iso_path        = "[DS-ISO] VMware-Tools-windows-12.0.5-19716617.iso"

vm_cpu_num              = 2
vm_ram                  = 8192
vm_disk_size            = 81920
*/
