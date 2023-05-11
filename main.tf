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
  key_name = aws_key_pair.auth-key
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  
 ingress {
    from_port        = 0
    to_port          = 22
    protocol         = "tcp"
  }
}
