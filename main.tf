variable "my_ip" {
  type        = string
  description = "my local ip address for connection"

}

variable "key_file" {
    type = string
    description = "system varible path to tf aws auth public key"
  
}

resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

  tags = {
    Name = "tf-dev"
  }
}

resource "aws_subnet" "tf_public_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "ap-southeast-2a"

  tags = {
    Name = "dev-subnet"
  }
}

resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "dev-igw"
  }
}

#create a public route table 
resource "aws_route_table" "tf_public_rt" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "dev_public_rt"
  }
}

resource "aws_route" "tf_default_route" {
  route_table_id         = aws_route_table.tf_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.tf_igw.id
  depends_on = [
    aws_internet_gateway.tf_igw
  ]
}

# assosiate route table tp subnet

resource "aws_route_table_association" "tf_public_assco" {
  subnet_id      = aws_subnet.tf_public_subnet.id
  route_table_id = aws_route_table.tf_public_rt.id

}

#security group

resource "aws_security_group" "tf_sg" {
  name        = "tf_dev_sg"
  description = "dev security group"
  vpc_id      = aws_vpc.tf_vpc.id

  ingress {

    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = [var.my_ip]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]

  }

}

resource "aws_key_pair" "tf_auth" {
    key_name = "key_file"
    public_key = file(var.key_file)
  
}

resource "aws_instance" "tf_dev_node" {
    instance_type = "t2.micro"
    ami = data.aws_ami.tf_ububtu_ami.id

    tags = {
      Name = "tf-dev-node"
    }

    key_name = aws_key_pair.tf_auth.id
    vpc_security_group_ids = [aws_security_group.tf_sg.id ]
    subnet_id = aws_subnet.tf_public_subnet.id
    #user_data = file("userdata.tpl")

    root_block_device {
      volume_size = 10
    }
  
}
