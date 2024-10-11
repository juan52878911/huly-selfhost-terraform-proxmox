# Generar una clave privada RSA
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Almacenar la clave privada localmente
resource "local_file" "ssh_key" {
  content  = tls_private_key.rsa_key.private_key_pem
  filename = "${path.module}/${var.key_name}.pem"

  provisioner "local-exec" {
    command = "chmod 600 ${path.module}/${var.key_name}.pem"
  }
}

# Variable para el nombre de la clave
variable "key_name" {
  description = "Name of the Proxmox key pair"
  default = "key"
}

resource "proxmox_lxc" "lxc-huly-srv" {
  target_node  = "pve"
  hostname     = "lxc-huly-srv"
  ostemplate   = "local:vztmpl/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
  password     = "52878911"
  unprivileged = true
  start        = true
  onboot       = true

  memory = 4096
  swap = 4096
  cores = 4

  // Clave publica 
  ssh_public_keys = tls_private_key.rsa_key.public_key_openssh

  // Terraform will crash without rootfs defined
  rootfs {
    storage = "local-lvm"
    size    = "8G"
  }

  features {
    nesting = true
  }

  network {
    name   = "eth0"
    bridge = "vmbr0"
    ip     = "192.168.2.30/24"
    gw     = "192.168.2.1"
  }

  # Provisión con script de usuario para habilitar SSH e instalar Docker
  provisioner "local-exec" {
    command = "touch dynamic_inventory.ini"
  }
}

data "template_file" "inventory" {
  template = <<-EOT
    [lxc_instances]
    ${replace(proxmox_lxc.lxc-huly-srv.network.0.ip, "/24", "")} ansible_user=root ansible_private_key_file=${path.module}/${var.key_name}.pem
    EOT
}

resource "local_file" "dynamic_inventory" {
  filename = "${path.module}/dynamic_inventory.ini"
  content  = data.template_file.inventory.rendered

  provisioner "local-exec" {
    command = "chmod 600 ${local_file.dynamic_inventory.filename}"
  }
}

resource "null_resource" "run_ansible" {
  depends_on = [local_file.dynamic_inventory]

  provisioner "local-exec" {
    command     = "ansible-playbook -i dynamic_inventory.ini install-docker-ansible.yml"
    working_dir = path.module
  }
}