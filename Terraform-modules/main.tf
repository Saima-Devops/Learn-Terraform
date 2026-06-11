module "network" {
  source   = "./modules/network"
  region   = var.region
  vpc_cidr = "10.0.0.0/16"
}

module "security" {
  source      = "./modules/security"
  vpc_id      = module.network.vpc_id
  environment = var.environment
}

module "compute" {
  source             = "./modules/compute"
  region             = var.region
  environment        = var.environment
  ami_id             = var.ami_id
  instance_type      = var.instance_type
  instance_count     = var.instance_count
  subnet_id          = element(module.network.public_subnet_ids, 0)
  security_group_ids = [module.security.web_sg_id]
}

module "storage" {
  source        = "./modules/storage"
  region        = var.region
  environment   = var.environment
  bucket_prefix = var.app_bucket_prefix
}
