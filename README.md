# Huly-Selfhost-Terraform-Proxmox

Este repositorio contiene la infraestructura como código (IaC) necesaria para desplegar una máquina LXC en **Proxmox** utilizando **Terraform** y **Ansible**. Posteriormente, se instala y configura el servicio de comunicaciones **Huly**, que es un servicio tipo Teams para la colaboración, sobre la máquina LXC.

## Arquitectura

- **Terraform**: Utilizado para definir y aprovisionar la máquina LXC en el hipervisor Proxmox.
- **Ansible**: Usado para configurar automáticamente la instancia LXC, instalando Docker, y montando el servicio Huly.
- **Proxmox**: Hipervisor utilizado para ejecutar la máquina virtual LXC.
- **Huly**: Servicio tipo Teams autohospedado para llamadas y colaboración.

## Requisitos Previos

Antes de empezar, asegúrate de tener lo siguiente:

1. **Proxmox** instalado y accesible desde tu red.
2. **Terraform** instalado en tu máquina local. [Guía de instalación](https://learn.hashicorp.com/tutorials/terraform/install-cli).
3. **Ansible** instalado en tu máquina local. [Guía de instalación](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html).
4. Claves SSH configuradas para acceder a Proxmox y la máquina LXC.
5. Docker instalado en la instancia LXC para ejecutar Huly.

## Estructura del Repositorio

```bash
├── huly-selfhost/
│   ├── compose.yaml             # Definición del servicio Docker para Huly
├── terraform/
│   ├── ansible.cfg              # Configuración de Ansible
│   ├── dynamic_inventory.ini    # Inventario dinámico generado por Terraform
│   ├── install-docker-ansible.yml # Playbook de Ansible para instalar Docker en LXC
│   ├── key.pem                  # Clave privada SSH (añadir a .gitignore)
│   ├── provider.tf              # Configuración del proveedor Proxmox en Terraform
│   ├── srv-huly.tf              # Recursos de Terraform para crear la máquina LXC
│   ├── start.sh                 # Script para iniciar el proceso de aprovisionamiento
│   └── README.md                # Este archivo
