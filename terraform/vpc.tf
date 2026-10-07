resource "aws_vpc" "tracker_vpc" {
    cidr_block = "10.0.0.0/16"
    tags = { Name = "tracker-vpc-tf" }
}

resource "aws_subnet" "tracker_public_subnet" {
    vpc_id                  = aws_vpc.tracker_vpc.id
    cidr_block              = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone       = "ap-south-1a"
    tags = { Name = "tracker-public-subnet-tf" }
}

resource "aws_internet_gateway" "tracker_igw" {
    vpc_id = aws_vpc.tracker_vpc.id
    tags = { Name = "tracker-igw-tf" }
}

resource "aws_route_table" "tracker_public_rt" {
    vpc_id = aws_vpc.tracker_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.tracker_igw.id
    }
    tags = { Name = "tracker-public-rt-tf" }
}

resource "aws_route_table_association" "tracker_rt_assoc" {
    subnet_id = aws_subnet.tracker_public_subnet.id
    route_table_id = aws_route_table.tracker_public_rt.id
}