resource "aws_iam_role" "ec2_s3_write_role" {
  name = "sujal-ec2-s3-write-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name    = "sujal-ec2-s3-write-role"
    Creator = "Sujal Phaiju"
  }
}

resource "aws_iam_policy" "s3_put_policy" {
  name        = "sujal-ec2-s3-put-policy"
  description = "Allow EC2 to put objects into S3"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject"
        ]
        Resource = "arn:aws:s3:::*/*" # Adjust to restrict to specific bucket
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_s3_put" {
  role       = aws_iam_role.ec2_s3_write_role.name
  policy_arn = aws_iam_policy.s3_put_policy.arn
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "sujal-ec2-instance-profile"
  role = aws_iam_role.ec2_s3_write_role.name
}

resource "aws_instance" "web" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  key_name                    = var.key_name
  associate_public_ip_address = true
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name

  tags = {
    Name    = "Sujal-Phaiju-EC2"
    Creator = "Sujal Phaiju"
  }
}

resource "aws_security_group" "web_sg" {
  name        = "sujal-ec2-sg"
  description = "Allow SSH, HTTP, and HTTPS"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "sujal-ec2-sg"
    Creator = "Sujal Phaiju"
  }
}

output "instance_arn" {
  value = aws_instance.web.arn
}

output "instance_role_arn" {
  value = aws_iam_role.ec2_s3_write_role.arn
}
