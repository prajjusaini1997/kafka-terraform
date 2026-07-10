terraform {
  backend "s3" {
    bucket         = "kafka-terraform-state-1709"
    key            = "kafka/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock"
    encrypt        = true
  }
}
