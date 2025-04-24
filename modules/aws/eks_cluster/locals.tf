locals {
  default_ingress_ports = [
    {
      # EKS API
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    },
    {
      # Kubelet
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    },
    # internal health check
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    },
    {
      # NodePorts
      from_port   = 30000
      to_port     = 32767
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    }
  ]

  default_egress_ports = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1" # Allow all outbound traffic
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  # Merge default values with user-provided values
  merged_ingress_ports = distinct(concat(local.default_ingress_ports, tolist(var.ingress_ports)))
  merged_egress_ports  = distinct(concat(local.default_egress_ports, tolist(var.egress_ports)))
}
