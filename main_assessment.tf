
# Create VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
}

# Create Public Subnet
resource "aws_subnet" "public_subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id     = aws_vpc.vpc.id
  tags = {
    Name = "public-subnet"
  }
}

# Create Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"
  vpc_id      = aws_vpc.vpc.id

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
}

# Create Security Group for RDS Instance
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
}

# Create RDS instance
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t4g.micro"
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot = true
}

# Create EC2 instance and add phpMyAdmin deployment to the EC2 instance
resource "aws_instance" "wordpress_instance" {
  ami                    = var.ami
  instance_type          = "t4g.small"
  subnet_id              = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
  key_name               = "my-key-pair"
  user_data              = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo amazon-linux-extras install -y docker
    sudo service docker start
    sudo usermod -aG docker ec2-user
    sudo docker run --name wordpress -p 80:80 -p 443:443 -d wordpress

    # Install phpMyAdmin
    sudo docker run --name phpmyadmin -d --link wordpress_db:db -p 8080:80 phpmyadmin/phpmyadmin
  EOF
}

# Create Elastic IP and associate it with EC2 instance
resource "aws_eip" "wordpress_eip" {
  instance = aws_instance.wordpress_instance.id
}

# Rollback on error
terraform {
  on_failure = "rollback"
}

# Output of public IP of EC2 istance
output "public_ip" {
  value = aws_instance.wordpress_instance.public_ip
}
