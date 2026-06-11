output "vpc_id" {
  description = "VPC id created by the network module"
  value       = module.network.vpc_id
}

output "public_subnets" {
  description = "Public subnet ids"
  value       = module.network.public_subnet_ids
}

output "security_group_id" {
  description = "Web security group id"
  value       = module.security.web_sg_id
}

output "instance_ids" {
  description = "EC2 instance ids"
  value       = module.compute.instance_ids
}

output "instance_public_ips" {
  description = "Public IPs of EC2 instances"
  value       = module.compute.instance_public_ips
}

output "app_bucket_name" {
  description = "Application S3 bucket created by storage module"
  value       = module.storage.bucket_name
}
