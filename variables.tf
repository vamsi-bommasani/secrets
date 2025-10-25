# ======================================================
# AWS
# ======================================================

variable "aws_region" {
  description = "provide the aws_region"
  type        = string
}

# ======================================================
# Tags
# ======================================================

variable "app_id" {
  description = "provide an app-id"
  type        = string
}

variable "environment" {
  description = "provide some environment name"
  type        = string
}

variable "engineer_mail" {
  description = "provide an email to send mails"
  type        = string
}
