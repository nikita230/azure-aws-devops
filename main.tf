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
 security_groups = ["aws_security_group.allow_ssh"]

 provisioner "remote-exec" {
 inline = [ 
  "sudo yum update –y",
  "sudo wget -O /etc/yum.repos.d/jenkins.repo \
    https://pkg.jenkins.io/redhat-stable/jenkins.repo",
  "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key"  ,
  "sudo yum upgrade",
  "sudo amazon-linux-extras install java-openjdk11 -y",
  "sudo dnf install java-11-amazon-corretto -y",
  "sudo yum install jenkins -y",
  "sudo systemctl enable jenkins",
  "sudo systemctl start jenkins",
  "sudo systemctl status jenkins"
  ]
 }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  
 ingress {
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
  }
   ingress {
    from_port        = 0
    to_port          = 8080
    protocol         = "tcp"
  }

}
