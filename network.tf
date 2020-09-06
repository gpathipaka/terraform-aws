resource "aws_vpc" "vpc_master" {
  provider             = aws.region-master
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    name = "Master-vpc-jenkins"
  }
}

#Create VPC in us-east-2
resource "aws_vpc" "vpc_master_ohio" {
  provider             = aws.region-worker
  cidr_block           = "192.168.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    name = "Worker-vpc-jenkins"
  }
}








resource "aws_internet_gateway" "igw" {
  provider = aws.region-master
  vpc_id   = aws_vpc.vpc_master.id
}

resource "aws_internet_gateway" "igw_ohio" {
  provider = aws.region-worker
  vpc_id   = aws_vpc.vpc_master_ohio.id
}


data "aws_availability_zones" "azs" {
  provider = aws.region-master
  state    = "available"
}

resource "aws_subnet" "subnet_1" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.1.0/24"
}

resource "aws_subnet" "subnet_2" {
  provider          = aws.region-master
  availability_zone = element(data.aws_availability_zones.azs.names, 1)
  vpc_id            = aws_vpc.vpc_master.id
  cidr_block        = "10.0.2.0/24"
}


resource "aws_subnet" "subnet_1_ohio" {
  provider   = aws.region-worker
  vpc_id     = aws_vpc.vpc_master_ohio.id
  cidr_block = "192.168.1.0/24"
}



