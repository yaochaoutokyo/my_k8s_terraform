# ubuntu ami
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_key_pair" "key" {
  key_name   = "kubernetes-key"
  public_key = file("kubernetes.pub")

  tags = {
    Terraform = "true"
    Name = "kubernetes"
  }
}

resource "aws_instance" "master-node" {
  count = 3

  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.key.key_name
  security_groups = [aws_security_group.kubernetes-sg.id]
  private_ip = "10.0.1.1${count.index}"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public-subnet.id

  user_data = "name=contoller-${count.index}"

  tags = {
    Terraform = "true"
    Name = "controller-${count.index}"
  }
}

resource "aws_instance" "worker-node" {
  count = 3

  ami = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name = aws_key_pair.key.key_name
  security_groups = [aws_security_group.kubernetes-sg.id]
  private_ip = "10.0.1.2${count.index}"
  subnet_id = aws_subnet.public-subnet.id
  associate_public_ip_address = true

  user_data = "name=worker-${count.index}|pod-cidr=10.200.${count.index}.0/24"

  tags = {
    Terraform = "true"
    Name = "worker-${count.index}"
  }
}