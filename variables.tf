variable "location" {
  description = "Azure region for all resources."
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group."
  type        = string
  default     = "red-team-lab-rg"
}

variable "vnet_name" {
  description = "Name of the lab virtual network."
  type        = string
  default     = "red-team-lab-vnet"
}

variable "vnet_address_space" {
  description = "Address space for the lab virtual network."
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "public_subnet_name" {
  description = "Name of the public subnet for the Kali VM."
  type        = string
  default     = "public-subnet"
}

variable "public_subnet_prefixes" {
  description = "Address prefixes for the public subnet."
  type        = list(string)
  default     = ["10.0.1.0/24"]
}

variable "private_subnet_name" {
  description = "Name of the private subnet for the target VM."
  type        = string
  default     = "private-subnet"
}

variable "private_subnet_prefixes" {
  description = "Address prefixes for the private subnet."
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "admin_username" {
  description = "Admin username for all Linux VMs."
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Local path to the SSH public key used to provision VM access."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "allowed_admin_cidr" {
  description = "CIDR block allowed to SSH into the Kali VM. Restrict this to your admin IP range."
  type        = string
  default     = "203.0.113.5/32"
}

variable "target_application_ports" {
  description = "Application ports allowed from the public subnet to the target VM."
  type        = list(string)
  default     = ["80", "443"]
}

variable "kali_vm_name" {
  description = "Name of the Kali attacker VM."
  type        = string
  default     = "kali-vm"
}

variable "target_vm_name" {
  description = "Name of the target VM."
  type        = string
  default     = "target-vm"
}

variable "kali_vm_size" {
  description = "VM size for the Kali attacker host."
  type        = string
  default     = "Standard_B2ms"
}

variable "target_vm_size" {
  description = "VM size for the target host."
  type        = string
  default     = "Standard_B2s"
}

variable "kali_image_publisher" {
  description = "Marketplace publisher for the Kali Linux image."
  type        = string
  default     = "kali-linux"
}

variable "kali_image_offer" {
  description = "Marketplace offer for the Kali Linux image."
  type        = string
  default     = "kali"
}

variable "kali_image_sku" {
  description = "Marketplace SKU for the Kali Linux image."
  type        = string
  default     = "kali-2026-1"
}

variable "kali_image_version" {
  description = "Marketplace image version for the Kali Linux image."
  type        = string
  default     = "2026.1.0"
}

variable "target_image_publisher" {
  description = "Marketplace publisher for the target VM image."
  type        = string
  default     = "Canonical"
}

variable "target_image_offer" {
  description = "Marketplace offer for the target VM image."
  type        = string
  default     = "0001-com-ubuntu-server-jammy-daily"
}

variable "target_image_sku" {
  description = "Marketplace SKU for the target VM image."
  type        = string
  default     = "22_04-daily-lts-gen2"
}

variable "target_image_version" {
  description = "Marketplace image version for the target VM image."
  type        = string
  default     = "22.04.202605150"
}
