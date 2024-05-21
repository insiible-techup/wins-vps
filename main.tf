data "aws_key_pair" "default" {
    key_name = "vps-key"
  
}

resource "aws_vpc" "net-main" {
    cidr_block = var.vpc-cidr
    enable_dns_hostnames = true

    tags = {
      Name = "${var.name}-vpc"
    }
  
}

resource "aws_subnet" "public" {
   
    vpc_id = aws_vpc.net-main.id
    cidr_block = "10.23.128.0/24"
    availability_zone = var.availability-zone

    tags = {
      Name = "${var.name}-pb"
    }
       
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.net-main.id
    cidr_block = "10.23.64.0/18"
    availability_zone =  var.availability-zone

    tags = {
      Name = "${var.name}-pr"
    }
       
}

resource "aws_eip" "nat" {
  domain   = "vpc"

}

resource "aws_nat_gateway" "natgw" {
   
    allocation_id = aws_eip.nat.id
    subnet_id = aws_subnet.public.id
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.net-main.id
  
}

resource "aws_route_table" "rt-public" {
    vpc_id = aws_vpc.net-main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw.id
    }
  
}

resource "aws_route_table" "rt-private" {
   
    vpc_id = aws_vpc.net-main.id
    

    route  {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_nat_gateway.natgw.id
    }
  
}

resource "aws_route_table_association" "pub-rtassoc" {
   
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.rt-public.id
}

resource "aws_route_table_association" "pri-rtassoc" {
 
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.rt-private.id
}

resource "aws_security_group" "vps_sg" {
  name        = "vpsadm-security-group"
  description = "Security group for vps-site"
  vpc_id = aws_vpc.net-main.id

  tags = {
    Name = "allow_vps_traffic"
  }
}


resource "aws_vpc_security_group_ingress_rule" "allow_ipv4" {
  security_group_id = aws_security_group.vps_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3389
  ip_protocol       = "tcp"
  to_port           = 3389
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.vps_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.vps_sg.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_network_interface" "vps-nic" {
 
  subnet_id       = aws_subnet.public.id
  private_ips     = ["10.23.128.100"]
  security_groups = [aws_security_group.vps_sg.id]
}


resource "aws_instance" "vps" {
  for_each = var.instance-name
  ami           = "ami-0f496107db66676ff"
  instance_type = var.instance-type
  key_name      = data.aws_key_pair.default.key_name
  subnet_id = aws_subnet.public.id
  availability_zone = var.availability-zone
  associate_public_ip_address = true
  vpc_security_group_ids = [aws_security_group.vps_sg.id]

  tags = {
    Name = "${each.value}-server"
  }
}