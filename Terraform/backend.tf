terraform {
  backend "s3" {
    bucket = "terraform-255552"
    key    = "terraform.tfstate"
    region = "us-east-1"
    dynamodb_table = "lock-terraform"
  }
}