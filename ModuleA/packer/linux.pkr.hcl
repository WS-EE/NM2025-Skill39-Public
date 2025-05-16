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
variable "root_password" {}
variable "meister_password" {}
variable "kohtunik_password" {}
variable "scorer_password" {}


source "proxmox-iso" "debian-base" {
  proxmox_url    = "https://${var.proxmox_hostname}/api2/json"
  username       = var.proxmox_api_token_id
  token          = var.proxmox_api_token_secret
  insecure_skip_tls_verify = true

  node           = var.proxmox_node
  qemu_agent = true
  scsi_controller = "virtio-scsi-pci"

  boot_iso {
    type = "scsi"
    iso_file = "${var.iso_storage}:${var.iso_path}"
    unmount = true
  }

  boot_wait = "10s"
  boot_command = [
    "<tab>",
    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
    "auto=true ",
    "priority=critical ",
    "preseed/url=http://{{ .HTTPIP }}:{{ .HTTPPort }}/preseed.cfg ",
    "<wait><enter>"
  ]

  ssh_username = "root"
  ssh_password = var.root_password
  ssh_port     = 22

  http_bind_address = "172.25.0.1"
  http_port_min     = 8801
  http_port_max     = 8899
  http_content = {
    "/preseed.cfg" = templatefile("http/preseed.cfg.pkrtpl.hcl",
      {
        var                   = var,
        root_password         = var.root_password
    })
  }
  ssh_timeout            = "30m"
  ssh_handshake_attempts = 1000
}

build {
  name    = "template-FW"

  source "source.proxmox-iso.debian-base" {
    vm_name = "template-FW"
    vm_id   = 901

    cores          = 2
    sockets        = 1
    memory         = 2048

    disks {
      disk_size         = "20G"
      format            = "raw"
      storage_pool      = var.vm_storage
      type              = "virtio"
    }

    network_adapters {
      model   = "virtio"
      bridge  = "vmbr0"
    }
  }

  provisioner "shell" {
    inline = [
      "hostnamectl set-hostname FW",
      "sed -i 's/debian/FW/g' /etc/hosts",
      "apt install -y vim curl wget dnsutils man-db",
      "useradd -m -s /bin/bash meister && echo 'meister:${var.meister_password}' | chpasswd",
      "useradd -m -s /bin/bash kohtunik && echo 'kohtunik:${var.kohtunik_password}' | chpasswd",
      "useradd -m -s /bin/bash scorer && echo 'scorer:${var.scorer_password}' | chpasswd",
      "usermod -aG sudo meister",
      "usermod -aG sudo kohtunik",
      "usermod -aG sudo scorer",
      "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd",
      "chmod 440 /etc/sudoers.d/nopasswd",
      "sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf",
      "sysctl -w net.ipv4.ip_forward=1"
      ]
  }
  
  provisioner "file" {
    source = "http/fw/interfaces"
    destination = "/etc/network/interfaces"
  }
}

build {
  name    = "template-PROXY"

  source "source.proxmox-iso.debian-base" {
    vm_name = "template-PROXY"
    vm_id   = 902

    cores          = 2
    sockets        = 1
    memory         = 2048

    disks {
      disk_size         = "20G"
      format            = "raw"
      storage_pool      = var.vm_storage
      type              = "virtio"
    }

    network_adapters {
      model   = "virtio"
      bridge  = "vmbr0"
    }
  }

  provisioner "shell" {
    inline = [
      "hostnamectl set-hostname PROXY",
      "sed -i 's/debian/PROXY/g' /etc/hosts",
      "apt install -y vim curl wget dnsutils man-db",
      "useradd -m -s /bin/bash meister && echo 'meister:${var.meister_password}' | chpasswd",
      "useradd -m -s /bin/bash kohtunik && echo 'kohtunik:${var.kohtunik_password}' | chpasswd",
      "useradd -m -s /bin/bash scorer && echo 'scorer:${var.scorer_password}' | chpasswd",
      "usermod -aG sudo meister",
      "usermod -aG sudo kohtunik",
      "usermod -aG sudo scorer",
      "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd",
      "chmod 440 /etc/sudoers.d/nopasswd"
      ]
  }
  
  provisioner "file" {
    source = "http/proxy/interfaces"
    destination = "/etc/network/interfaces"
  }
}


build {
  name    = "template-NS"

  source "source.proxmox-iso.debian-base" {
    vm_name = "template-NS"
    vm_id   = 903

    cores          = 2
    sockets        = 1
    memory         = 2048

    disks {
      disk_size         = "20G"
      format            = "raw"
      storage_pool      = var.vm_storage
      type              = "virtio"
    }

    network_adapters {
      model   = "virtio"
      bridge  = "vmbr0"
    }
  }

  provisioner "shell" {
    inline = [
      "hostnamectl set-hostname NS",
      "sed -i 's/debian/NS/g' /etc/hosts",
      "apt install -y vim curl wget dnsutils man-db",
      "useradd -m -s /bin/bash meister && echo 'meister:${var.meister_password}' | chpasswd",
      "useradd -m -s /bin/bash kohtunik && echo 'kohtunik:${var.kohtunik_password}' | chpasswd",
      "useradd -m -s /bin/bash scorer && echo 'scorer:${var.scorer_password}' | chpasswd",
      "usermod -aG sudo meister",
      "usermod -aG sudo kohtunik",
      "usermod -aG sudo scorer",
      "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd",
      "chmod 440 /etc/sudoers.d/nopasswd"
      ]
  }
  
  provisioner "file" {
    source = "http/ns/interfaces"
    destination = "/etc/network/interfaces"
  }
}


build {
  name    = "template-SRV"

  source "source.proxmox-iso.debian-base" {
    vm_name = "template-SRV"
    vm_id   = 904

    cores          = 2
    sockets        = 1
    memory         = 2048

    disks {
      disk_size         = "20G"
      format            = "raw"
      storage_pool      = var.vm_storage
      type              = "virtio"
    }

    network_adapters {
      model   = "virtio"
      bridge  = "vmbr0"
    }
  }

  provisioner "shell" {
    inline = [
      "hostnamectl set-hostname SRV",
      "sed -i 's/debian/SRV/g' /etc/hosts",
      "apt install -y vim curl wget dnsutils man-db",
      "useradd -m -s /bin/bash meister && echo 'meister:${var.meister_password}' | chpasswd",
      "useradd -m -s /bin/bash kohtunik && echo 'kohtunik:${var.kohtunik_password}' | chpasswd",
      "useradd -m -s /bin/bash scorer && echo 'scorer:${var.scorer_password}' | chpasswd",
      "usermod -aG sudo meister",
      "usermod -aG sudo kohtunik",
      "usermod -aG sudo scorer",
      "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd",
      "chmod 440 /etc/sudoers.d/nopasswd",
      "apt install -y dosfstools"
      ]
  }
  
  provisioner "file" {
    source = "http/srv/interfaces"
    destination = "/etc/network/interfaces"
  }
}

build {
  name    = "template-WEB"

  source "source.proxmox-iso.debian-base" {
    vm_name = "template-WEB"
    vm_id   = 905

    cores          = 2
    sockets        = 1
    memory         = 2048

    disks {
      disk_size         = "20G"
      format            = "raw"
      storage_pool      = var.vm_storage
      type              = "virtio"
    }

    network_adapters {
      model   = "virtio"
      bridge  = "vmbr0"
    }
  }

  provisioner "shell" {
    inline = [
      "hostnamectl set-hostname WEB",
      "sed -i 's/debian/WEB/g' /etc/hosts",
      "apt install -y vim curl wget dnsutils man-db",
      "useradd -m -s /bin/bash meister && echo 'meister:${var.meister_password}' | chpasswd",
      "useradd -m -s /bin/bash kohtunik && echo 'kohtunik:${var.kohtunik_password}' | chpasswd",
      "useradd -m -s /bin/bash scorer && echo 'scorer:${var.scorer_password}' | chpasswd",
      "usermod -aG sudo meister",
      "usermod -aG sudo kohtunik",
      "usermod -aG sudo scorer",
      "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd",
      "chmod 440 /etc/sudoers.d/nopasswd"
      ]
  }
  
  provisioner "file" {
    source = "http/web/interfaces"
    destination = "/etc/network/interfaces"
  }
}

build {
  name    = "template-ADMIN"

  source "source.proxmox-iso.debian-base" {
    vm_name = "template-ADMIN"
    vm_id   = 906

    cores          = 2
    sockets        = 1
    memory         = 2048

    disks {
      disk_size         = "20G"
      format            = "raw"
      storage_pool      = var.vm_storage
      type              = "virtio"
    }

    network_adapters {
      model   = "virtio"
      bridge  = "vmbr0"
    }
  }

  provisioner "shell" {
    inline = [
      "hostnamectl set-hostname ADMIN",
      "sed -i 's/debian/ADMIN/g' /etc/hosts",
      "apt install -y vim curl wget dnsutils man-db firefox-esr",
      "useradd -m -s /bin/bash meister && echo 'meister:${var.meister_password}' | chpasswd",
      "useradd -m -s /bin/bash kohtunik && echo 'kohtunik:${var.kohtunik_password}' | chpasswd",
      "useradd -m -s /bin/bash scorer && echo 'scorer:${var.scorer_password}' | chpasswd",
      "usermod -aG sudo meister",
      "usermod -aG sudo kohtunik",
      "usermod -aG sudo scorer",
      "echo '%sudo ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/nopasswd",
      "chmod 440 /etc/sudoers.d/nopasswd",
      "apt install -y gdm3 gnome-shell gnome-terminal gnome-text-editor ",
      "apt install -y ansible ansible-core sshpass",
      "wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor -o /etc/apt/trusted.gpg.d/microsoft.gpg",
      "echo 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main' > /etc/apt/sources.list.d/vscode.list",
      "apt update",
      "apt install -y code",
      "mkdir -p /home/meister/ansible"
      ]
  }
  
  provisioner "file" {
    source = "http/admin/interfaces"
    destination = "/etc/network/interfaces"
  }

  provisioner "file" {
    source = "http/admin/ansible/ansible.cfg"
    destination = "/home/meister/ansible/ansible.cfg"
  }

  provisioner "file" {
    source = "http/admin/ansible/hosts.yaml"
    destination = "/home/meister/ansible/hosts.yaml"
  }

  provisioner "shell" {
    inline = [
      "chown -R meister:meister /home/meister/ansible"
    ]
  }

  provisioner "shell" {
    inline = [
      "mkdir -p /root/.ssh",
      "mkdir -p /home/scorer/.ssh",
      "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtsxcoAmilrhLSlWd0Ub4A8URSh+WPph1jeeixjIdwZ' >> /root/.ssh/authorized_keys",
      "echo 'ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJtsxcoAmilrhLSlWd0Ub4A8URSh+WPph1jeeixjIdwZ' >> /home/scorer/.ssh/authorized_keys",
      "chmod 700 /root/.ssh /home/scorer/.ssh",
      "chmod 600 /root/.ssh/authorized_keys /home/scorer/.ssh/authorized_keys",
      "chown -R root:root /root/.ssh",
      "chown -R scorer:scorer /home/scorer/.ssh"
    ]
  }

}
