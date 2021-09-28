resource "aws_instance" "vm-web" {
  ami           = var.ami
  instance_type = var.ec2_instance_type
  vpc_security_group_ids = [ aws_security_group.websg.id ]
  user_data = <<-EOF
                #!/bin/bash
                sudo su
                yum update
                yum -y install httpd
                echo "<p> My Instance! </p>" >> /var/www/html/index.html
                sudo systemctl enable httpd
                sudo systemctl start httpd
                EOF
  tags = var.tags
}
resource "aws_security_group" "websg" {
  name = "web-sg01"
  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = [ "0.0.0.0/0" ]
  }
  egress {
    protocol = "-1"
    from_port = 0
    to_port = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
