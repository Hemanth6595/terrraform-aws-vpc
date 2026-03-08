resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = "default"
  enable_dns_hostnames = true
  
    tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id # VPC assosiation
  tags = local.igw_final_tags
}

#public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block =var.public_subnet_cidrs[count.index]
  availability_zone =local.aws_availability_zones_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,{
      #roboshop-dev-public-us-east-1a
      #roboshop-dev-public-us-east-1b
      Name ="${var.project}-${var.environment}-public-subnet-${local.aws_availability_zones_names[count.index]}"
    } ,
    var.public_subnet_tags
  )
}

#private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block =var.private_subnet_cidrs[count.index]
  availability_zone =local.aws_availability_zones_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,{
      #roboshop-dev-public-us-east-1a
      #roboshop-dev-public-us-east-1b
      Name ="${var.project}-${var.environment}-private-subnet-${local.aws_availability_zones_names[count.index]}"
    } ,
    var.private_subnet_tags
  )
}

#private subnets
resource "aws_subnet" "database" {
  count = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.main.id
  cidr_block =var.database_subnet_cidrs[count.index]
  availability_zone =local.aws_availability_zones_names[count.index]
  map_public_ip_on_launch = true
  tags = merge(
    local.common_tags,{
      #roboshop-dev-public-us-east-1a
      #roboshop-dev-public-us-east-1b
      Name ="${var.project}-${var.environment}-database-subnet-${local.aws_availability_zones_names[count.index]}"
    } ,
    var.database_subnet_tags
  )
}


resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,{
      #roboshop-dev-public
      #roboshop-dev-public
      Name ="${var.project}-${var.environment}-public"
    } ,
    var.public_route_table_tags
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,{
      #roboshop-dev-public
      #roboshop-dev-public
      Name ="${var.project}-${var.environment}-private"
    } ,
    var.private_route_table_tags
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id
  tags = merge(
    local.common_tags,{
      #roboshop-dev-public
      #roboshop-dev-public
      Name ="${var.project}-${var.environment}-database"
    } ,
    var.database_route_table_tags
  )
}