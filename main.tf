provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket = "github-actions-terraform-state-bucket-2024"
    key    = "terraform-state-file"
    dynamodb_table = "terraform-state-file-table-2024"
    region = "us-east-1"
  }
}


resource "aws_vpc" "demo-vpc" {
  cidr_block = "10.20.0.0/16"
  
  tags = {
    Name = "Demo VPC"
  }
}

resource "aws_internet_gateway" "demo-igw" {
  vpc_id = aws_vpc.demo-vpc.id

  tags = {
    Name = "Demo Internet Gateway"
  }
}

resource "aws_route_table" "demo-route-table" {
  vpc_id = aws_vpc.demo-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.demo-igw.id
  }

  tags = {
    Name = "Demo Route Table"
  }
}

resource "aws_route_table_association" "demo-route-table-association" {
  subnet_id      = aws_subnet.demo-subnet.id
  route_table_id = aws_route_table.demo-route-table.id
}

resource "aws_subnet" "demo-subnet" {
  vpc_id            = aws_vpc.demo-vpc.id
  availability_zone = "us-east-1a"
  cidr_block        = "10.20.1.0/24"

  tags = {
    Name = "Demo Subnet"
  }
}

resource "aws_security_group" "demo-sg" {
  vpc_id = aws_vpc.demo-vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Demo Security Group"
  }
}

resource "aws_instance" "demo-instance" {
  ami           = "ami-04b70fa74e45c3917" # Ubuntu
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.demo-subnet.id
  
  vpc_security_group_ids      = [aws_security_group.demo-sg.id]
  associate_public_ip_address = true
  key_name                    = "myAwsKeyPair"

  tags = {
    Name = "Public EC2 Instance"
  }
}
