# EventBridge rule to trigger Lambda based on the specified schedule
resource "aws_cloudwatch_event_rule" "lambda_trigger_rule" {
  name                = var.event_rule_name
  description         = var.event_description
  schedule_expression = var.schedule_expression
}

# EventBridge target to invoke the Lambda function
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.lambda_trigger_rule.name
  arn       = var.lambda_arn
  input     = jsonencode(var.event_params) # Pass parameters as JSON input

  # Grant permission to EventBridge to invoke the Lambda function
  depends_on = [aws_lambda_permission.allow_eventbridge]
}

# Lambda permission to allow EventBridge to invoke the function
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowEventBridgeInvocation-${var.statement_id_suffix}"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_arn
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.lambda_trigger_rule.arn
}