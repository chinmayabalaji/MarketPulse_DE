terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 6.0"
        }
    }

    backend "s3" {
        bucket = "terraform-amzn-infra-backend-bucket"
        key = "terraform.tfstate"
        region = "eu-north-1"
        encrypt = true
        use_lockfile = true
    }
}

provider "aws" {
    region = "eu-north-1"
}

