/*
  Project       : 
  Created On    : 08-04-2024
*/


# Configure the AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      terraform  = true
      project    = "Sample Project"
      created_by = "terraform"
    }
  }
}