# Secrets

## KMS
* Create and control keys used to encrypt or digitally sign your data
## Secrets Manager
* Centrally manage the lifecycle of secrets
## SSM Parameter Store
* A Parameter Store parameter is any piece of data that is saved in Parameter Store

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.18 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.18.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_kms"></a> [kms](#module\_kms) | terraform-aws-modules/kms/aws | 4.1.1 |
| <a name="module_secrets_manager"></a> [secrets\_manager](#module\_secrets\_manager) | terraform-aws-modules/secrets-manager/aws | 2.0.1 |
| <a name="module_ssm_parameters"></a> [ssm\_parameters](#module\_ssm\_parameters) | terraform-aws-modules/ssm-parameter/aws | 1.2.0 |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | provide an app-id | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | provide the aws\_region | `string` | n/a | yes |
| <a name="input_engineer_mail"></a> [engineer\_mail](#input\_engineer\_mail) | provide an email to send mails | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | provide some environment name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | n/a |
| <a name="output_secret_arn"></a> [secret\_arn](#output\_secret\_arn) | n/a |
| <a name="output_secret_name"></a> [secret\_name](#output\_secret\_name) | n/a |
<!-- END_TF_DOCS -->

<!-- Terratest Executions -->
To run the infrastructure tests using Terratest, follow these steps:

1. Make sure you have Go installed on your system
2. Navigate to the terratests directory:
   ```bash
   cd terratests/
   ```

3. Download required Go dependencies:
   ```bash
   go mod tidy
   ```

4. Run the tests:
   ```bash
   go test -v
   ```

Note: Make sure you have valid AWS credentials configured before running the tests. The tests will create real AWS resources in your account for validation.
<!-- END Terratest Executions-->
