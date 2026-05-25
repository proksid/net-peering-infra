# -------------------------
# VPC
# -------------------------
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-vpc"
  })
}

# -------------------------
# Internet Gateway
# -------------------------
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-igw"
  })
}

# -------------------------
# Public subnet for NAT Gateway
# -------------------------
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true
  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-public-subnet"
    Tier = "public"
  })
}

# -------------------------
# Private app subnet
# For EC2 app server
# -------------------------

resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_app_subnet_cidr
  availability_zone = var.availability_zone
  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-private-app-subnet"
    Tier = "private-app"
  })
}

# -------------------------
# Private DB subnet
# PostgreSQL/RDS or EC2 DB server
# -------------------------
resource "aws_subnet" "private_db" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_db_subnet_cidr
  availability_zone = var.availability_zone
  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-private-db-subnet"
    Tier = "private-db"
  })
}

# -------------------------
# Public route table
# public subnet -> Internet Gateway
# -------------------------
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-public-rt"
  })
}

resource "aws_route" "public_default" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# -------------------------
# NAT Gateway
# Created only if app or DB subnet needs outbound internet.
# -------------------------
resource "aws_eip" "nat" {
  count = var.app_subnet_has_nat_route || var.db_subnet_has_nat_route ? 1 : 0

  domain = "vpc"

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-nat-eip"
  })
}

resource "aws_nat_gateway" "this" {
  count = var.app_subnet_has_nat_route || var.db_subnet_has_nat_route ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-nat"
  })

  depends_on = [
    aws_internet_gateway.this
  ]
}

# -------------------------
# Private app route table
# private app subnet -> optional NAT Gateway
# -------------------------
resource "aws_route_table" "private_app" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-private-app-rt"
  })
}

resource "aws_route_table_association" "private_app" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_app.id
}

resource "aws_route" "private_app_default" {
  count = var.app_subnet_has_nat_route ? 1 : 0

  route_table_id         = aws_route_table.private_app.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

# -------------------------
# Private DB route table
# private DB subnet -> optional NAT Gateway
# -------------------------
resource "aws_route_table" "private_db" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-private-db-rt"
  })
}

resource "aws_route_table_association" "private_db" {
  subnet_id      = aws_subnet.private_db.id
  route_table_id = aws_route_table.private_db.id
}

resource "aws_route" "private_db_default" {
  count = var.db_subnet_has_nat_route ? 1 : 0

  route_table_id         = aws_route_table.private_db.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id
}

# -------------------------
# App security group
# Attached to app EC2 instance
# -------------------------

resource "aws_security_group" "app" {
  name        = "${var.name}-${var.environment}-app-sg"
  description = "Security group for application instances"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-app-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "app_ssh" {
  count = var.ssh_allowed_cidr == null ? 0 : 1

  security_group_id = aws_security_group.app.id
  description = "Allow SSH to app instances if ssh_allowed_cidr is set"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = var.ssh_allowed_cidr
}

resource "aws_vpc_security_group_ingress_rule" "app_direct" {
  count = var.app_allowed_cidr == null ? 0 : 1

  security_group_id = aws_security_group.app.id
  description = "Allow direct access to app port if app_allowed_cidr is set"
  ip_protocol = "tcp"
  from_port   = var.app_port
  to_port     = var.app_port
  cidr_ipv4   = var.app_allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "app_all_outbound" {
  security_group_id = aws_security_group.app.id
  description = "Allow app instances outbound access"
  ip_protocol = "-1"
  cidr_ipv4   = "0.0.0.0/0"
}

# -------------------------
# DB security group
# Attached to DB EC2 instance or RDS PostgreSQL
# ------------------------
resource "aws_security_group" "db" {
  name        = "${var.name}-${var.environment}-db-sg"
  description = "Security group for database instances"
  vpc_id      = aws_vpc.this.id

  tags = merge(var.tags, {
    Name = "${var.name}-${var.environment}-db-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
  security_group_id = aws_security_group.db.id
  description                  = "Allow db client from app security group"
  ip_protocol                  = "tcp"
  from_port                    = var.db_port
  to_port                      = var.db_port
  referenced_security_group_id = aws_security_group.app.id
}

resource "aws_vpc_security_group_ingress_rule" "db_ssh" {
  count = var.db_ssh_allowed_cidr == null ? 0 : 1
  security_group_id = aws_security_group.db.id
  description = "Allow SSH to DB instances"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
  cidr_ipv4   = var.db_ssh_allowed_cidr
}

resource "aws_vpc_security_group_ingress_rule" "db_direct_access" {
  count = var.db_port_allowed_cidr == null ? 0 : 1
  security_group_id = aws_security_group.db.id
  description = "Allow direct db client access to DB instances"
  ip_protocol = "tcp"
  from_port   = var.db_port
  to_port     = var.db_port
  cidr_ipv4   = var.db_port_allowed_cidr
}

resource "aws_vpc_security_group_egress_rule" "db_to_vpc" {
  security_group_id = aws_security_group.db.id
  description = "Allow DB outbound inside VPC"
  ip_protocol = "-1"
  cidr_ipv4   = var.vpc_cidr
}

# -------------------------
# DB subnet group
# For RDS PostgreSQL
# -------------------------
#resource "aws_db_subnet_group" "postgres" {
#   name       = "${var.name}-${var.environment}-postgres-subnet-group"
#   subnet_ids = [aws_subnet.private_db.id]
#
#   tags = merge(var.tags, {
#     Name = "${var.name}-${var.environment}-postgres-subnet-group"
#   })
# }

