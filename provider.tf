terraform {
  required_version = ">= 0.12"
  backend "s3" {
    bucket = "tf-backendfiles"
    key    = "path/to/my/key"
    region = "us-west-1"
  }
  
}

provider "aws" {
  region = "us-west-1"

}