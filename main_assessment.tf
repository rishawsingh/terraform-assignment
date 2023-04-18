# Create Security Group for EC2 Instance
resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"
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

# Create EC2 instance and add phpMyAdmin deployment to the EC2 instance
resource "aws_instance" "wordpress_instance" {
  ami                    = var.ami
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]
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
# Create Security Group for RDS Instance
resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"


  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.ec2_sg.id]
  }
}

# Create RDS instance
resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 10
  engine               = "mysql"
  instance_class       = "db.t3.micro"
  name                 = var.name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql8.0"
  vpc_security_group_ids = [aws_security_group.rds_sg.id]

}



# Create Elastic IP and associate it with EC2 instance
resource "aws_eip" "wordpress_eip" {
  instance = aws_instance.wordpress_instance.id
}

# Associate the Elastic IP with the EC2 instance
resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress_instance.id
  allocation_id = aws_eip.wordpress_eip.id
}
