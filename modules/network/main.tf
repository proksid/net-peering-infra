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