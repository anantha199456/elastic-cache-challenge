
resource "aws_vpc" "default" {
  cidr_block       = var.default_cidr_vpc
  enable_dns_support = "true" #gives you an internal domain name
  enable_dns_hostnames = "true" #gives you an internal host name
  instance_tenancy = "default"

  tags = {
    Name = "${var.namespace}-vpc"
  }
}

//PRIVATE SUBNET - RDS 

resource "aws_subnet" "private_subnet_1" {
  vpc_id     = aws_vpc.default.id
  cidr_block = var.private_cidr_block_1
  availability_zone = "us-east-1a"
  tags = {
    Name = "${var.namespace}-private-subnet-1"
  }
}

resource "aws_route_table" "private-route" {
    vpc_id = "${aws_vpc.default.id}"

    tags  = {
        Name = "${var.namespace}-private-subnet1-rt"
    }
}

resource "aws_route_table_association" "private-route-association-1" {
    subnet_id = "${aws_subnet.private_subnet_1.id}"
    route_table_id = "${aws_route_table.private-route.id}"
}

//PRIVATE SUBNET - REDIS 


resource "aws_subnet" "private_subnet_2" {
  vpc_id     = aws_vpc.default.id
  cidr_block = var.private_cidr_block_2
  availability_zone = "us-east-1b"
  tags = {
    Name = "${var.namespace}-private-subnet-2"
  }
}

resource "aws_route_table" "private-route-2" {
    vpc_id = "${aws_vpc.default.id}"

    tags = {
        Name = "${var.namespace}-private-subnet2-rt"
    }
}

resource "aws_route_table_association" "private-route-association-2" {
    subnet_id = "${aws_subnet.private_subnet_2.id}"
    route_table_id = "${aws_route_table.private-route-2.id}"
}


resource "aws_internet_gateway" "igw" {
    vpc_id = "${aws_vpc.default.id}"
}

//PUBLIC SUBNET 
resource "aws_subnet" "public_subnet" {
  vpc_id     = aws_vpc.default.id
  cidr_block = var.public_cidr_block
  availability_zone = var.az_zone
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.namespace}-public-subnet"
  }
}

resource "aws_route_table" "public-route" {
    vpc_id = "${aws_vpc.default.id}"

    route {
        cidr_block = var.all_allow_block
        gateway_id = "${aws_internet_gateway.igw.id}"
    }

    tags = {
        Name = "${var.namespace}-public-subnet-rt"
    }
}

resource "aws_route_table_association" "public-route-association" {
    subnet_id = "${aws_subnet.public_subnet.id}"
    route_table_id = "${aws_route_table.public-route.id}"
}

//NACLS 

resource "aws_network_acl" "default_nacl" {
  vpc_id     = aws_vpc.default.id
  subnet_ids = [aws_subnet.public_subnet.id,aws_subnet.private_subnet_1.id,aws_subnet.private_subnet_2.id]
  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = var.all_allow_block
    from_port  = 80
    to_port    = 80
  }


  ingress {
    protocol   = "tcp"
    rule_no    = 103
    action     = "allow"
    cidr_block = var.all_allow_block
    from_port  = 22
    to_port    = 22
  }

  ingress {
    protocol   = "tcp"
    rule_no    = 104
    action     = "allow"
    cidr_block = var.all_allow_block
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.all_allow_block
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = var.all_allow_block
    from_port  = 0
    to_port    = 0
  }


  tags = {
    Name = "${var.namespace}-public-acl"
  }
}

//Security Group for EC2

resource "aws_security_group" "sg_ec2" {
  name        = "allow_ec2_sg"
  description = "EC2 Security Group"
  vpc_id      = aws_vpc.default.id

  egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    } 
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }    

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }
    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        cidr_blocks = ["10.0.2.0/24"]
    }

    tags = {
        Name = "ec2-SG"
    }
}

//Security Group for RDS

# Create a security group that allows inbound connections on port 5432
resource "aws_security_group" "postgres_sg" {
  vpc_id = aws_vpc.default.id
  name = "postgres_sg"

  ingress {
    protocol  = "tcp"
    self      = true
    from_port = 5432
    to_port   = 5432
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Postgres_SG"
  }
}

//Security Group for Redis

resource "aws_security_group" "redis-sg" {
    vpc_id = aws_vpc.default.id
    description = "Redis Security Group"
    
    egress {
        from_port = 0
        to_port = 0
        protocol = -1
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 5000
        to_port = 5000
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 6379
        to_port = 6379
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "redis-sg"
    }
}