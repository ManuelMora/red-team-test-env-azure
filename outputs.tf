output "resource_group_name" {
  description = "Name of the resource group created for the lab."
  value       = azurerm_resource_group.lab.name
}

output "kali_public_ip" {
  description = "Public IP address of the Kali VM."
  value       = azurerm_public_ip.kali.ip_address
}

output "kali_private_ip" {
  description = "Private IP address of the Kali VM."
  value       = azurerm_network_interface.kali.ip_configuration[0].private_ip_address
}

output "target_private_ip" {
  description = "Private IP address of the target VM."
  value       = azurerm_network_interface.target.ip_configuration[0].private_ip_address
}

output "ssh_connect_command" {
  description = "SSH command to connect to the Kali VM."
  value       = "ssh ${var.admin_username}@${azurerm_public_ip.kali.ip_address}"
}
