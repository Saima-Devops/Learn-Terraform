# EC2 Instance outputs (match resource names in main.tf)
output "instance_id" {
  description = "ID of the EC2 instance(s)"
  value       = aws_instance.web_server[*].id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance(s)"
  value       = aws_instance.web_server[*].public_ip
}

output "instance_private_ip" {
  description = "Private IP address of the EC2 instance(s)"
  value       = aws_instance.web_server[*].private_ip
}

output "instance_type" {
  description = "Instance type(s) of the EC2 instance(s)"
  value       = aws_instance.web_server[*].instance_type
}

# Security Group outputs
output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.web_sg.id
}

# Variable / type demonstration outputs (use variables that exist)
output "environment_info" {
  description = "Environment information from string type variable"
  value = {
    name         = var.environment
    type         = "string"
    is_staging   = var.environment == "staging"
    display_name = upper(var.environment)
  }
}

output "storage_info" {
  description = "Storage information from number type variable"
  value = {
    disk_size_gb = var.storage_size
    disk_size_mb = var.storage_size * 1024
    type         = "number"
  }
}

output "tags_info" {
  description = "Tags from map type variable"
  value = {
    tags       = var.instance_tags
    tag_count  = length(keys(var.instance_tags))
    tag_keys   = keys(var.instance_tags)
    tag_values = values(var.instance_tags)
    type       = "map(string)"
  }
}

output "allowed_instance_types_info" {
  description = "Instance types from list type variable"
  value = {
    allowed_types = var.allowed_instance_types
    count         = length(var.allowed_instance_types)
    selected      = length(var.allowed_instance_types) > 0 ? var.allowed_instance_types[0] : ""
    type          = "list(string)"
  }
}

output "network_configuration" {
  description = "Network configuration from tuple type variable"
  value = {
    tuple_value   = var.network_config
    vpc_cidr      = local.vpc_cidr
    subnet_prefix = local.subnet_prefix
    cidr_bits     = local.cidr_bits
    subnet_full   = "${local.subnet_prefix}/${local.cidr_bits}"
    type          = "tuple([string, string, number])"
  }
}

output "server_configuration" {
  description = "Server configuration from object type variable"
  value = {
    config        = var.server_config
    instance_type = var.server_config.instance_type
    monitoring    = var.server_config.monitoring
    storage_gb    = var.server_config.storage_gb
    backup        = var.server_config.backup_enabled
    type          = "object"
  }
}

output "all_resource_tags" {
  description = "All tags applied to resources (local common_tags)"
  value       = local.common_tags
}