locals {
  common_tags = merge(
    {
      Name        = "type-constraints-${var.environment}"
      Environment = var.environment
      Module      = "Type-Constraints"
    },
    var.instance_tags
  )

  # Derived values from tuple network_config
  vpc_cidr      = element(var.network_config, 0)
  subnet_prefix = element(var.network_config, 1)
  cidr_bits     = element(var.network_config, 2)
}