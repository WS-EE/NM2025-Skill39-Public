packer {
  required_plugins {
    name = {
      version = "= 1.2.1" # use specifically 1.2.1 since 1.2.2 has bugs.
      source  = "github.com/hashicorp/proxmox"
    }
  }
}
variable "proxmox_hostname" {}
variable "proxmox_api_token_id" {}
variable "proxmox_api_token_secret" {}
variable "proxmox_node" {}
variable "vm_storage" {}
variable "iso_storage" {}
variable "iso_path" {}

source "proxmox-iso" "windows2025" {
  proxmox_url    = "https://${var.proxmox_hostname}/api2/json"
  username       = var.proxmox_api_token_id
  token          = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  node           = var.proxmox_node
  qemu_agent = true
  scsi_controller = "virtio-scsi-pci"

  bios = "ovmf"
  machine = "q35"
  efi_config {
    efi_storage_pool = var.vm_storage
    pre_enrolled_keys = true
    efi_type = "4m"
  }

  boot_iso {
    type = "scsi"
    iso_file = "${var.iso_storage}:${var.iso_path}"
    unmount = true
  }

  additional_iso_files {
    cd_files = ["./files/drivers-2k25/*","./files/software/virtio-win-guest-tools.exe"]
    cd_content = {
      "autounattend.xml" = templatefile("./files/templates/unattend.xml.pkrtpl.hcl", {password = "Passw0rd!", cdrom_drive = "E:"})
    }
    cd_label = "Unattend"
    iso_storage_pool = var.iso_storage
    unmount = true
    type = "sata"
  }


  template_name = "packer-win2025"
  template_description = "Created on: ${timestamp()}"
  vm_name = "packer-win2025"
  vm_id = "39998"
  memory = 4096
  cores = 4
  sockets = 2
  cpu_type = "host"
  os = "win11"

  disks {
    disk_size         = "100G"
    format            = "raw"
    storage_pool      = var.vm_storage
    type              = "scsi"
    cache_mode = "writeback"
  }

  network_adapters {
    model   = "virtio"
    bridge  = "vmbr0"
  }

  communicator  = "ssh"
  ssh_username  = "Administrator"
  ssh_password  = "Passw0rd!"
  ssh_timeout   = "12h"
  
  boot_wait = "10s"
  boot_command = [
    "<enter>"
  ]
}

build {
  name = "Proxmox Build"
  sources = ["source.proxmox-iso.windows2025"]

  provisioner "windows-restart" {
  }
}