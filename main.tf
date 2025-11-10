module "kms" {
  source  = "terraform-aws-modules/kms/aws"
  version = "4.1.1"

  description             = "KMS key for encryption"
  key_usage               = "ENCRYPT_DECRYPT"
  deletion_window_in_days = 7
  enable_key_rotation     = false
  enable_default_policy   = true

  key_owners                             = [local.aws_account_id]
  key_administrators                     = [local.aws_account_id]
  key_users                              = [local.aws_account_id]
  key_service_users                      = [local.aws_account_id]
  key_service_roles_for_autoscaling      = ["arn:aws:iam::${local.aws_account_id}:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"]
  key_symmetric_encryption_users         = [local.aws_account_id]
  key_hmac_users                         = [local.aws_account_id]
  key_asymmetric_public_encryption_users = [local.aws_account_id]
  key_asymmetric_sign_verify_users       = [local.aws_account_id]

  key_statements = [
    {
      sid = "CloudWatchLogs"
      actions = [
        "kms:Encrypt*",
        "kms:Decrypt*",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:Describe*"
      ]
      resources = ["*"]

      principals = [
        {
          type        = "Service"
          identifiers = ["logs.${var.aws_region}.amazonaws.com"]
        }
      ]

      condition = [
        {
          test     = "ArnLike"
          variable = "kms:EncryptionContext:aws:logs:arn"
          values = [
            "arn:aws:logs:${var.aws_region}:${local.aws_account_id}:log-group:*"
          ]
        }
      ]
    }
  ]

  aliases                 = ["${var.aws_region}-${var.environment}-kms"]
  aliases_use_name_prefix = true
}

module "secrets_manager" {
  source  = "terraform-aws-modules/secrets-manager/aws"
  version = "2.0.1"

  name_prefix             = "${var.aws_region}-${var.environment}-secret"
  description             = "Secrets Manager secret"
  recovery_window_in_days = 7

  kms_key_id = module.kms.key_id

  create_policy       = true
  block_public_policy = true

  policy_statements = {
    read = {
      sid = "AllowAccountRead"
      principals = [{
        type        = "AWS"
        identifiers = ["arn:aws:iam::${local.aws_account_id}:root"]
      }]
      actions   = ["secretsmanager:GetSecretValue"]
      resources = ["*"]
    }
  }

  secret_string = jsonencode({
    Email       = var.engineer_mail
    Environment = var.environment
  })
}

module "ssm_parameters" {
  source      = "terraform-aws-modules/ssm-parameter/aws"
  version     = "2.0.0"
  for_each    = local.ssm_parameters
  name        = each.key
  type        = each.value.type
  value       = each.value.value
  description = each.value.description
  key_id      = module.kms.key_id
  overwrite   = true
}
