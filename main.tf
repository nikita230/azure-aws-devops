resource "aws_key_pair" "auth-key" {
  key_name = "auth-key"
  public_key = tls_private_key.rsa.public_key_openssh
}


resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_instance" "demo-vm" {
   depends_on = [ aws_key_pair.auth-key ]
  ami= "ami-051ed863837a0b1b6"
  instance_type = "t2.micro"
  key_name = "auth-key"
  security_groups = [aws_security_group.allow_ssh.name]
#  connection {
#     type     = "ssh"
#     user     = "root"
#     host     = self.public_ip
#    #private_key = aws_key_pair.auth-key
#    host_key = "aws_key_pair.auth-key"
#   }

user_data = <<-EOF
  #!bin/bash
  yum update –y
  wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
  rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  yum upgrade -y
  amazon-linux-extras install java-openjdk11 -y
  yum install jenkins -y
  systemctl enable jenkins
  systemctl start jenkins
  EOF
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = "vpc-0f4accded9b409126"
  
 ingress {
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }
   ingress {
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = [ "0.0.0.0/0" ]
  }

}
