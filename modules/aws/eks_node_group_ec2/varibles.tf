variable "tags" {
  description = "A map of tags to be applied to the resources."
  type        = map(string)
}

# IAM Role
# ===================================

# IAM Policy
# ===================================

# IAM Role Policy Attachment
# ===================================
variable "cluster_iam_role_name" {
  description = "The name of the IAM role associated with the EKS cluster."
  type        = string
}

# Security Group
# ===================================
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the resources will be deployed."
}

variable "cidr_block" {
  description = "The CIDR block for the ingress os EKS."
  type        = string
  validation {
    condition     = can(cidrnetmask(var.cidr_block))
    error_message = "The CIDR block must be a valid value."
  }
}

variable "ingress_ports" {
  description = "A set of ingress port configurations for the security group."
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

variable "egress_ports" {
  description = "A set of egress port configurations for the security group."
  type = set(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
  }))
  default = []
}

# EKS Node Group
# ===================================
variable "node_group_name" {
  description = "The name of the EKS node group."
  type        = string
}

variable "cluster_name" {
  description = "The name of the EKS cluster."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs for the EKS Node Group."
  type        = list(string)
}

variable "capacity_type" {
  description = ""
  type        = string
  default     = "ON_DEMAND"
  validation {
    condition     = contains(["ON_DEMAND", "SPOT"], var.capacity_type)
    error_message = "`capacity_type` must be 'ON_DEMAND' or 'SPOT'."
  }
}

variable "disk_size" {
  description = "Disk size in GiB for worker nodes. Defaults to 20GiB."
  type        = number
  default     = 20
}

variable "instance_type" {
  description = "EC2 instance type for the EKS worker nodes."
  type        = list(string)
}

# launch_template
variable "launch_template" {
  description = ""
  type = object({
    id      = string
    version = string
  })
  default = {
    id      = null
    version = null
  }
}

# scaling_config
variable "max_size" {
  description = "The maximum capacity (number of nodes) for the EKS worker node group."
  type        = number
  default     = 3
}

variable "desired_size" {
  description = "The desired capacity (number of nodes) for the EKS worker node group."
  type        = number
  default     = 2
  validation {
    condition     = (var.desired_size >= var.min_size) && (var.desired_size <= var.max_size)
    error_message = "`desired_size` value must be between `min_size` and `maz_size` included."
  }
}

variable "min_size" {
  description = "The minimum capacity (number of nodes) for the EKS worker node group."
  type        = number
  default     = 1
}

# remote_access
variable "ec2_ssh_key" {
  description = ""
  type        = string
  default     = null
}

# update_config
variable "max_unavailable_percentage" {
  description = "Desired max number of unavailable worker nodes during node group update in percentage."
  type        = number
  default     = 30
}
