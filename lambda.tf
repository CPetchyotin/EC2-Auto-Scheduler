# 1. IAM Role (Principal)
resource "aws_iam_role" "lambda_exec" {
  name = "lambda-ec2-scheduler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

# 2. Given Policy to Role to be able to  Start/Stop EC2
resource "aws_iam_policy" "lambda_ec2_policy" {
  name        = "lambda-ec2-scheduler-policy"
  description = "Permissions for Lambda to stop and start EC2 instances"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances",
          "ec2:DescribeInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# 3. Connect Policy with Role
resource "aws_iam_role_policy_attachment" "lambda_attach" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_ec2_policy.arn
}

data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "scheduler.py"
  output_path = "lambda_function_payload.zip" 
}

resource "aws_lambda_function" "ec2_scheduler" {
  filename      = data.archive_file.lambda_zip.output_path
  function_name = "ec2-auto-scheduler"
  role          = aws_iam_role.lambda_exec.arn
  handler       = "scheduler.lambda_handler"
  runtime       = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2_scheduler.function_name
  principal     = "events.amazonaws.com"
  

  
}