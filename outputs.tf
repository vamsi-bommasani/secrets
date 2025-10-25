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
