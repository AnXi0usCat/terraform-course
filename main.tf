terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "myapp-bucket"
    key = "myapp/state.tfstate"
    region = "eu-west-1"
  }
}

provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "myapp-vpc" { 
  cidr_block = var.vpc_cidr_block
  tags = {
    Name: "${var.env_prefix}-vpc"
  }
}

module "myapp-subnet" {
  source = "./modules/subnet"

  vpc_id = aws_vpc.myapp-vpc.id
  subnet_cidr_block = var.subnet_cidr_block
  avail_zone = var.avail_zone
  env_prefix = var.env_prefix
}

module "myapp-webserver" {
  source = "./modules/webserver"

  vpc_id = aws_vpc.myapp-vpc.id
  env_prefix = var.env_prefix
  my_ip_address = var.my_ip_address
  public_key_location = var.public_key_location
  instance_type = var.instance_type
  subnet_id = module.myapp-subnet.subnet.id
  avail_zone = var.avail_zone
}

resource "aws_route_table_association" "a-rtb-subnet" {
    subnet_id = module.myapp-subnet.subnet.id
    route_table_id = module.myapp-subnet.route_table.id
}


