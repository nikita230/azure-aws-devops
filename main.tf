resource "aws_instance" "demo-vm" {
  ami= "ami-051ed863837a0b1b6"
  instance_type = "t2.micro"
}