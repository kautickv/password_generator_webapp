# Variables for Lambda ARN and schedule
variable "lambda_arn" {
  description = "ARN of the Lambda function to trigger"
  type        = string
}

variable "event_params" {
  description = "Parameters to pass to the Lambda function"
  type        = map(any)
  default     = {
    action = "auto"
  }
}

variable "event_rule_name" {
  description = "Name of the event rule"
  type        = string
}

variable "event_description" {
  description = "Description of the event"
  type = string
}

variable "schedule_expression" {
  description = "Cron expression for the EventBridge schedule"
  type        = string
  default     = "cron(0 6,18 * * ? *)" # Default to 6AM and 6PM daily
}

variable "statement_id_suffix" {
  description = "Unique suffix for the Lambda permission statement ID"
  type        = string
}