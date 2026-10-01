output "application_name" {
  value = random_string.suffix.result
}

output "unique_name" {
  value = local.unique_name
}

output "enable_monitoring" {
  value = var.enable_monitoring
}

output "regions" {
  value = var.regions
}

output "eviroment_tags" {
  value = var.eviroment_tags
}

output "application_config" {
  value = var.application_config
}

output "allowed_networks" {
  value = var.allowed_networks
}