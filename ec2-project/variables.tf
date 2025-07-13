variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  default = "t2.micro"
  type    = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC of our Team E "
  type        = string
}

variable "subnet_id" {
  description = "The ID of public subnet in VPC Team E"
  type        = string
}