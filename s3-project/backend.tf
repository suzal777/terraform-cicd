terraform {
  backend "s3" {
    bucket       = "sujal-s3-tf-backend-bucket"
    key          = "prod/s3/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}