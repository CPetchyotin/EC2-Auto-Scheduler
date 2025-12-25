variable "aws_region" {
  description ="AWS region to deploy resources"
  type  = string
  default = "ap-southeast-1"
}
variable "instance_type" {
  type = string
   default = "t3.micro"
}
variable "key_name" {
    description = "SSH Key pair name"
    type = string
    default = "cpetch"
}