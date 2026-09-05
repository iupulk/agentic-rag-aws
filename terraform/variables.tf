variable "budget_alert_email" {
  description = "Email address for the AWS Budgets alert. Real value lives in terraform.tfvars (gitignored), never committed."
  type        = string
}