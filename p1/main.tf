terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.32.0"
    }
  }
}
provider "aws" {
  profile = "ashwani"
  region  = var.AWS-REGION
}

resource "aws_vpc" "myvpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name        = "myvpc",
    Application = "Infrastructure"
  }
}

resource "aws_internet_gateway" "myvpc-igw" {
    vpc_id = aws_vpc.myvpc.id
    tags = {
      Name        = "myvpc-igw",
      Application = "Infrastructure"
  }
}

# resource "aws_internet_gateway_attachment" "igw-attach" {
#     internet_gateway_id = aws_internet_gateway.myigw.id 
#     vpc_id = aws_vpc.myvpc.id 
# }

resource "aws_subnet" "public_subnet" {
  count             = length(var.public-subnet-cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = element(var.public-subnet-cidr, count.index)
  availability_zone = element(var.az, count.index)
  tags = {
    Name        = "myvpc-pub-sub-${count.index + 1}"
    Application = "Infrastructure"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private-subnet-cidr)
  vpc_id            = aws_vpc.myvpc.id
  cidr_block        = element(var.private-subnet-cidr, count.index)
  availability_zone = element(var.az, count.index)
  tags = {
    Name        = "myvpc-pri-sub-${count.index + 1}"
    Application = "Infrastructure"
  }
}


