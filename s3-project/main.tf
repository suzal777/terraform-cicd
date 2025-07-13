data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket = "sujal-ec2-tf-backend-bucket"
    key    = "prod/ec2/terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_s3_bucket" "project_bucket" {
  bucket = var.bucket_name

  tags = {
    Name    = "sujal-phaiju-tf-bucket"
    Creator = "Sujal Phaiju"
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.project_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_policy" "project_bucket" {
  bucket = aws_s3_bucket.project_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          AWS = data.terraform_remote_state.ec2.outputs.instance_role_arn
        }
        Action   = "s3:PutObject"
        Resource = "${aws_s3_bucket.project_bucket.arn}/*"
      }
    ]
  })
  depends_on = [data.terraform_remote_state.ec2]
}

resource "aws_s3_bucket" "project_bucket" {
  bucket = "sujal-test-tf-bucket"

  tags = {
    Name    = "sujal-test-tf-bucket"
    Creator = "Sujal Phaiju"
  }
}