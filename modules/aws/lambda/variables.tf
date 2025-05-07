variable "function_name" {
  description = "Name of the Lambda function"
  type        = string
}

variable "tags" {
  description = "Tags to be applied to the Lambda function"
  type        = map(string)  
}

variable "function_path" {
  description = "Path to the Lambda function code"
  type        = string
  default     = "hello_world"
}

variable "runtime" {
  description = "Runtime of the Lambda function"
  type        = string
  default     = "python3.11"
}

variable "handler" {
  description = "Handler of the Lambda function"
  type        = string
  default     = "main.handler"
}
