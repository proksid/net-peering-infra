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

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "app_instance" {
  source = "../../modules/instance"
  name        = "app"
  role        = "app"
  environment = var.environment

  ami_id             = data.aws_ami.amazon_linux.id
  instance_type      = var.app_instance_type
  subnet_id          = module.network.private_app_subnet_id
  security_group_ids = [module.network.app_security_group_id]

  key_name           = null
  # user_data = templatefile("${path.module}/user_data/app.sh.tftpl", {
  #   name     = "app"
  #   app_port = var.app_port
  # })

  tags = local.tags
}
