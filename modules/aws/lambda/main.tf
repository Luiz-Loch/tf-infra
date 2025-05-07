data "archive_file" "this" {
  type        = "zip"
  source_dir  = "${path.module}/functions/${var.function_path}"
  output_path = "${path.module}/build/${var.function_name}.zip"
}

resource "aws_lambda_function" "this" {
  function_name     = var.function_name
  description       = "Lambda function for ${var.function_name}"
  runtime           = var.runtime
  handler           = var.handler
  role              = aws_iam_role.this.arn
  filename          = data.archive_file.this.output_path
  source_code_hash  = data.archive_file.this.output_base64sha256
  tags = var.tags
}


resource "aws_cloudwatch_log_group" "example" {
  name              = "/aws/lambda/${var.function_name}"
  retention_in_days = 30
}