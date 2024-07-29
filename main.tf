resource "aws_default_subnet" "az1" {
  availability_zone = "us-east-2a"
}

data "aws_ami" "ubuntu_22_04_server_amd_64" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_iam_instance_profile" "main" {
  name = "my-instance"
  role = aws_iam_role.main.name
  tags = local.default_tags
}

resource "aws_iam_role" "main" {
  name = "my-instance-role"
  tags = local.default_tags
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = ["ec2.amazonaws.com"]
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}



resource "aws_security_group" "main" {
  name        = "my-instance-sg"
  description = "Security group for private bastion instance"
  vpc_id      = aws_default_subnet.az1.vpc_id
  tags        = local.default_tags
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.main.id
}

resource "aws_instance" "main" {
  ami                         = data.aws_ami.ubuntu_22_04_server_amd_64.id
  instance_type               = "t3.small"
  vpc_security_group_ids      = [aws_security_group.main.id]
  subnet_id                   = aws_default_subnet.az1.id
  user_data_replace_on_change = true

  instance_market_options {
    market_type = "spot"
    spot_options {
      spot_instance_type             = "persistent"
      instance_interruption_behavior = "stop"
    }
  }

  root_block_device {
    volume_size = 20
    encrypted   = true
  }

  iam_instance_profile = aws_iam_instance_profile.main.name

  tags = merge({
    Name = "my-instance",
  }, local.default_tags)
}

