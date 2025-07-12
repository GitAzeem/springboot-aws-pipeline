terraform {
  backend "s3" {
    bucket = "mybackend7800"
    key    = "springboot-aws-pipeline/terraform.tfstate"
    region = "us-east-1"
    encrypt = true
  }
}
