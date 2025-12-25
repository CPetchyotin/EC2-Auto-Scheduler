# Check EC2's id that was created
output "ec2_instance_id" {
  description = "The ID of the EC2 instance"
  value       = aws_instance.auto_ec2.id
}

# Check Lambda Function ARN
output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.ec2_scheduler.arn
}

# Check EventBridge Rule Name
output "eventbridge_rule_name" {
  description = "The name of the EventBridge rule"
  value       = aws_cloudwatch_event_rule.stop_instances_rule.name
}