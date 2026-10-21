
# Look up the existing default VPC
data "aws_vpc" "default" {
  default = true
}

# Discover subnets in the default VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Create a dedicated security group for Redshift
resource "aws_security_group" "redshift" {
  name        = "dw-redshift-sg"
  description = "Security group for StockVerse Redshift Serverless"
  vpc_id      = data.aws_vpc.default.id

  # No inbound access until a database client is configured.

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "dw-redshift-sg"
  }
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_subnet_ids" {
  value = data.aws_subnets.default.ids
}

output "redshift_security_group_id" {
  value = aws_security_group.redshift.id
}
