### Create a VPC ###

resource "aws_vpc" "myvpc" {
  cidr_block           = var.vpc-cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "myvpc"

  }
}
### Internet Gateway #####

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.myvpc.id

  tags = {
    Name = "myvpc"
  }
}

###Elastic IP Address
resource "aws_eip" "eip" {
   vpc      = true
}

## Nat Gateway

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public.0.id

  tags = {
    Name = "myvpc-natgateway"
  }
}

### AWS Routing Table ###

resource "aws_route_table" "public-rt" {
  vpc_id = aws_vpc.myvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "myvpc-public-rt"
  }
}

resource "aws_default_route_table" "private-rt" {
  default_route_table_id = aws_vpc.myvpc.default_route_table_id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "myvpc-private-rt"
  }
}

### AWS Subnet Associated with Routing tables ###

resource "aws_route_table_association" "a" {
  count = length(var.public-subnet-cidr)
  #subnet_id      = aws_subnet.public.*.id[count.index]
  subnet_id      = element(aws_subnet.public.*.id, count.index)

  route_table_id = aws_route_table.public-rt.id
}

resource "aws_route_table_association" "b" {
  count = length(var.private-subnet-cidr)
   subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_default_route_table.private-rt.id
}





