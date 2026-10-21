resource "aws_security_group" "tracker_sg" {
  name   = "tracker-sg-tf"
  vpc_id = aws_vpc.tracker_vpc.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.ssh_cidr]
  }

  ingress {
    description = "App port"
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.app_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "tracker-sg-tf" }
}

resource "aws_instance" "tracker_instance" {
  ami                    = "ami-05a7c953f702ad6dd"
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.tracker_public_subnet.id
  vpc_security_group_ids = [aws_security_group.tracker_sg.id]
  key_name               = aws_key_pair.tracker_key.key_name


  tags = { Name = "tracker-instance-tf" }
}

resource "aws_key_pair" "tracker_key" {
  key_name   = "tracker-key-tf"
  public_key = file(pathexpand(var.ssh_public_key_path))
}

output "instance_public_ip" {
  value = aws_instance.tracker_instance.public_ip
}