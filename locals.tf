locals {
  aws_account_id = data.aws_caller_identity.current.account_id

  ssm_parameters = {
    "Email" = {
      type        = "String"
      value       = "var.engineer_mail"
      description = "sample email"
    },
    "Environment" = {
      type        = "SecureString"
      value       = "var.environment"
      description = "sample environment"
    }
  }
}
