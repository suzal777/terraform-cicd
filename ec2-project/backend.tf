terraform {
  backend "s3" {
    bucket         = "sujal-ec2-tf-backend-bucket"
    key            = "prod/ec2/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    use_lockfile   = true
  }
}