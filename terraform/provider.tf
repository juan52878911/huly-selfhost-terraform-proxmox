terraform {
  required_version = ">= 0.13.0"

  required_providers {
    proxmox = {
        source = "Telmate/proxmox"
        version = "3.0.1-rc4"
    }
  }
}

variable "proxmox_api_url" {
  type = string
  description = "Proxmox API URL"
}

variable "proxmox_api_token_id" {
  type = string
  sensitive = true
  description = "Proxmox API Token ID"
}

variable "proxmox_api_token_secret" {
  type = string
  sensitive = true
  description = "Proxmox API Token Secret"
}

provider "proxmox" {
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret

  pm_tls_insecure = true

  # Debugging
  pm_log_enable = true
  pm_log_file   = "terraform-plugin-proxmox.log"
  pm_debug      = true
  pm_log_levels = {
    _default    = "debug"
    _capturelog = ""
  }
}