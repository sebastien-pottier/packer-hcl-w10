/* 
Specify any declared variables from the file of, variables.pkr.hcl, to override default values.
Example of default value of var cpu_name is 2 cores. We override that with 4 cores below.
*/

vcenter_username        = "administrator@vsphere.local"
vcenter_password        = "Rootroot123+"

os_username             = "Packer"
os_password_workstation = "P@ssw0rd!"

vcenter_server          = "vcenter.intranet.pottier.eu"
vcenter_cluster         = "Cluster"
vcenter_datacenter      = "Datacenter"
vcenter_host            = "esx5.intranet.pottier.eu"
vcenter_datastore       = "DS-nas-1"
vcenter_folder          = "packer-templates/win"

vm_name                 = "win10_pro_x64_packer_template"
vm_network              = "VM Network"
vm_guest_os_type        = "windows9_64Guest" # Refer to https://code.vmware.com/apis/704/vsphere/vim.vm.GuestOsDescriptor.GuestOsIdentifier.html for guest OS types.
vm_version              = "19" # Refer to https://kb.vmware.com/s/article/1003746 for specific VM versions.

os_iso_path             = "[DS-ISO] windows_10_x64_21H2.iso"
vmtools_iso_path        = "[DS-ISO] windows_vmware_tools_v12.0.0-19345655.iso"

cpu_num                 = 4
ram                     = 8192
disk_size               = 81920