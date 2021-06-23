

//pending userdata.sh script

# resource "aws_network_interface" "network_interface" {
#   subnet_id       = var.public_subnet_id
#   security_groups = [var.public_sg_id]  
#   associate_public_ip_address = true
#   attachment {
#     instance     = aws_instance.web-instance.id
#     device_index = 0
#   }
# }

resource "aws_instance" "web-instance" {
  ami           = "ami-0aeeebd8d2ab47354" 
  instance_type = "t2.micro"
  key_name = "demo-terraform"
  subnet_id = var.public_subnet_id
  vpc_security_group_ids = [var.public_sg_id]
  user_data = file("${path.module}/userdata.sh")
  # network_interface {
  #   network_interface_id = aws_network_interface.network_interface.id
  #   device_index         = 0
  # }

  tags = {
    "Name" = "${var.namespace}-ec2"
  }
}

# resource "aws_key_pair" "kpacgecc" {
#     key_name = "demo-terraform"
#     public_key = file("${path.module}/demo-terraform.pem")
# }

