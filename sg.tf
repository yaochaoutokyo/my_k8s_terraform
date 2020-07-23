resource "aws_security_group" "kubernetes-sg" {
  # 必须使用name-prefix，因为lifecycle设置为create_before_destroy
  name = "kubernetes"
  description = "kubernetes security group"
  vpc_id = aws_vpc.kubernetes-vpc.id

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["10.200.0.0/16"]
  }

  ingress {
    from_port = 22
    to_port = 22
    protocol = "TCP"
    description = "allow ssh from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 6443
    to_port = 6443
    protocol = "TCP"
    description = "allow access API server from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 0
    to_port = 0
    protocol = "icmp"
    description = "allow ping from anywhere"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "allow all"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # terraform先创建一个新的sg，再替换旧的
//  lifecycle {
//    create_before_destroy = true
//  }

  tags = {
    Terraform   = "true"
    Name = "kubernetes"
  }
}