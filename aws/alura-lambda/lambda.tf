module "lambda" {
  source        = "../../modules/aws/lambda"
  function_name = "alura-lambda"
  runtime       = "python3.13"
  tags          = local.tags
}
