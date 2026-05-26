name        = "net-peering"
environment = "dev"

vpc_cidr                = "10.10.0.0/16"
public_subnet_cidr      = "10.10.1.0/24"
private_app_subnet_cidr = "10.10.11.0/24"
private_db_subnet_cidr  = "10.10.21.0/24"

availability_zone = "ca-central-1"

app_port = 8000
db_port  = 5432

app_subnet_has_nat_route = true

db_subnet_has_nat_route = false

# Optional debug access.
ssh_allowed_cidr     = null
app_allowed_cidr     = null
db_ssh_allowed_cidr  = null
db_port_allowed_cidr = null
