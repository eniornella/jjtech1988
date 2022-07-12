
resource "aws_instance" "jjtechweb" {
  ami = var.ami_id
  instance_type = var.instance_type
}


output "jjtech-ec2"{
  value = aws_instance.jjtechweb.public_ip
}


resource "aws_eip" "lb" {
  vpc = true
  tags = {
    Name = "jjtecheip"
  }
}

output "jjtech-eip" {
  value = aws_eip.lb.id
}


resource "aws_eip_association" "eip_assoc" {
instance_id   = aws_instance.jjtechweb.id
  allocation_id = aws_eip.lb.id
}
/*
resource "aws_security_group" "allow_tls" {
  name        = var.security_group_name
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
   description      = "allow http only from eip"
   from_port        = 80
   to_port          = 80
   protocol         = "tcp"
   cidr_blocks      = [aws_eip.lb.public_ip]

 }

}
*/

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block
  tags = {
    Name = "jjtechvpc"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_subnet

  tags = {
    Name = "jjtechsubnetpublic"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

    route  {
       cidr_block   =  var.cidr_block_rt
      gateway_id = aws_internet_gateway.gw.id
    }
  }

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "jjtechigw"
  }
}
resource "aws_route_table_association" "associate" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}
