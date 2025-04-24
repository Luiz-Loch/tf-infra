variable "tags" {
  type = map(string)
}

variable "name" {
  type = string
}

# EC2 Security Group
# ===================================
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the resources will be deployed."
}

variable "ingress_ports" {
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "A set of ingress port configurations for the security group."
}

variable "egress_ports" {
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  description = "A set of egress port configurations for the security group."
}

# IAM Role
# ===================================

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================

# IAM Instance Profile
# ===================================

# IAM Instance
# ===================================
variable "image_id" {
  type        = string
  description = "The ID of the Amazon Machine Image (AMI) to be used for the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "The EC2 instance type (e.g., 't2.micro', 'm5.large')."
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet where the EC2 instance will be launched."
}

variable "key_name" {
  type        = string
  default     = null
  description = "The name of the SSH key pair stored in AWS Key Manager."
}

variable "monitoring" {
  type = bool
  description = "If true, the launched EC2 instance will have detailed monitoring enabled."
  
}

variable "volume_size" {
  type        = number
  description = "The size of the root volume (in GiB)."
}

variable "volume_type" {
  type        = string
  description = "The type of the root volume (e.g., 'gp2', 'gp3', 'io1')."
  validation {
    condition     = contains(["gp2", "gp3", "io1", "io2", "st1", "sc1", "standard"], var.volume_type)
    error_message = "The 'volume_type' variable must be one of 'gp2', 'gp3', 'io1', 'io2', 'st1', 'sc1', or 'standard'."
  }
}

variable "delete_on_termination" {
  type        = bool
  default     = true
  description = "Whether the root volume should be deleted when the EC2 instance is terminated."
}

variable "user_data" {
  type        = string
  default     = null
  description = "User data script that will be executed when the EC2 instance is created. Can use the file() function to load content."
}

# EC2 Elastic IP
# ===================================
variable "elastic_ip" {
  type        = bool
  description = "If true, an Elastic IP will be assigned to the EC2 instance."
  default     = false
}

variable "elastic_ip_domain" {
  type        = string
  description = "Elastic IP domain. The default is 'vpc', which is required for instances within a VPC."
  default     = "vpc"
}