# IAM Policy Document
# ===================================
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    
    actions = [
      "sts:AssumeRole"
    ]
  }
}

# IAM Role
# ===================================
resource "aws_iam_role" "this" {
  name               = "${var.function_name}-iam-role"
  description        = "IAM role for Lambda function"
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags               = var.tags
}

# IAM Role POlicy Attachment
# ===================================
# https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AWSLambdaBasicExecutionRole.html
resource "aws_iam_role_policy_attachment" "AWSLambdaBasicExecutionRole" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
