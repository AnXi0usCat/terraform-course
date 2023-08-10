provider "aws" {
  region = "eu-west-1"
}

resource "aws_vpc" "development-vpc" { 
  cidr_block = var.cidr_blocks[0].cidr_block
  tags = {
    Name:    var.cidr_blocks[0].name
    vpc_env: "dev"
  }
}

variable "cidr_blocks" {
  description = "cidr blocks for the environment"
  type        = list(object({name = string, cidr_block = string}))
}

resource "aws_subnet" "dev-subnet-1" {
  vpc_id = aws_vpc.development-vpc.id
  cidr_block = "10.0.0.0/20"
  availability_zone = "eu-west-1a"
  tags = {
    Name: "subnet-dev-1"
  }
}

data "aws_vpc" "existing_vpc" {
    id = aws_vpc.development-vpc.id
  
}

resource "aws_subnet" "dev-subnet-2" {
  vpc_id = data.aws_vpc.existing_vpc.id
  cidr_block = var.cidr_blocks[1].cidr_block
  availability_zone = "eu-west-1b"
  tags = {
    Name: var.cidr_blocks[1].name
  }
}


output "dev-vpc-id" {
  value =  aws_vpc.development-vpc.id
}

output "dev-subnet-id" {
  value =  aws_subnet.dev-subnet-1.id
}
