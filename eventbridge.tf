resource "aws_cloudwatch_event_rule" "stop_instances_rule" {
    name                = "stop-ec2-at-1800"
    description         = "Triggers Lambda to stop EC2 instances at 6 PM every weekday"
    schedule_expression = "cron(0 11 ? * MON-FRI *)"
}

resource "aws_cloudwatch_event_target" "stop_ec2_target" {
    rule      = aws_cloudwatch_event_rule.stop_instances_rule.name
    target_id = "StopEC2Target"
    arn       = aws_lambda_function.ec2_scheduler.arn
    input =  jsonencode({
        action = "stop"
    })
  
}