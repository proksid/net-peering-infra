module "network" {
  source = "../../modules/network"

  name        = var.name
  environment = var.environment

  vpc_cidr                = var.vpc_cidr
  public_subnet_cidr      = var.public_subnet_cidr
  private_app_subnet_cidr = var.private_app_subnet_cidr
  private_db_subnet_cidr  = var.private_db_subnet_cidr
  availability_zone       = var.availability_zone

  app_subnet_has_nat_route = var.app_subnet_has_nat_route
  db_subnet_has_nat_route  = var.db_subnet_has_nat_route

  app_port = var.app_port
  db_port  = var.db_port

  ssh_allowed_cidr     = var.ssh_allowed_cidr
  app_allowed_cidr     = var.app_allowed_cidr
  db_ssh_allowed_cidr  = var.db_ssh_allowed_cidr
  db_port_allowed_cidr = var.db_port_allowed_cidr

  tags = local.tags
}
