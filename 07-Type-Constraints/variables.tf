variable "region" {
  description = "AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "environment must be one of: dev, staging, prod"
  }
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1

  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 5
    error_message = "instance_count must be between 1 and 5"
  }
}

variable "ami_id" {
  description = "AMI id to use for EC2 instances"
  type        = string
  default     = ""
}

variable "storage_size" {
  description = "Storage size (GB) example number variable"
  type        = number
  default     = 20
}

variable "instance_tags" {
  description = "Map of tags to apply to instances"
  type        = map(string)
  default     = {}
}

variable "allowed_instance_types" {
  description = "Example list variable of allowed instance types"
  type        = list(string)
  default     = ["t3.micro", "t3.small"]
}

variable "network_config" {
  description = "Example tuple [vpc_cidr, subnet_prefix, cidr_bits]"
  type        = tuple([string, string, number])
  default     = ["10.0.0.0/16", "10.0.1.0", 24]
}

variable "server_config" {
  description = "Example server configuration object"
  type = object({
    instance_type  = string
    monitoring     = bool
    storage_gb     = number
    backup_enabled = bool
  })

  default = {
    instance_type  = "t3.micro"
    monitoring     = false
    storage_gb     = 8
    backup_enabled = false
  }
}