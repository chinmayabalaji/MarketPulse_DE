resource "aws_redshiftserverless_namespace" "redshift_dw" {
  namespace_name        = "Market_Pulse"
  db_name               = "Market_Pulse"
  admin_username        = "admin"
  manage_admin_password = true
  iam_roles = [
    aws_iam_role.lambda_execution_role.arn
  ]
  default_iam_role_arn = aws_iam_role.lambda_execution_role.arn
}

resource "aws_redshiftserverless_workgroup" "redshift_dw" {
  workgroup_name      = "Market_Pulse"
  namespace_name      = aws_redshiftserverless_namespace.redshift_dw.namespace_name
  base_capacity       = 2
  publicly_accessible = false
  port                = 5439
  subnet_ids          = data.aws_subnets.default.ids
  security_group_ids = [
    aws_security_group.redshift.id
  ]
}

output "redshift_namespace_name" {
  value = aws_redshiftserverless_namespace.redshift_dw.namespace_name
}

output "redshift_database_name" {
  value = aws_redshiftserverless_namespace.redshift_dw.db_name
}

output "redshift_workgroup_name" {
  value = aws_redshiftserverless_workgroup.redshift_dw.workgroup_name
}

output "redshift_endpoint" {
  value = aws_redshiftserverless_workgroup.redshift_dw.endpoint[0].address
}

output "redshift_port" {
  value = aws_redshiftserverless_workgroup.redshift_dw.endpoint[0].port
}

output "redshift_admin_secret_arn" {
  value     = aws_redshiftserverless_namespace.redshift_dw.admin_password_secret_arn
  sensitive = true
}