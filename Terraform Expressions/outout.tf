output "nsg-name" {
  value = azurerm_network_security_group.nsg-example.name
}

output "nsg-names" {
  value = [for count in local.nsg_rules : count.description]

}

output "splat" {
  value = local.nsg_rules[*].allow_http

}
