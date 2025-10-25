output "secret_name" {
  value = module.secrets_manager.secret_name
}

output "secret_arn" {
  value = module.secrets_manager.secret_arn
}

output "kms_key_id" {
  value = module.kms.key_id
}

output "kms_key_arn" {
  value = module.kms.key_arn
}

output "ssm_parameter_names" {
  value = [for param in module.ssm_parameters : param.name]
}

output "ssm_parameter_arns" {
  value = [for param in module.ssm_parameters : param.arn]
}
