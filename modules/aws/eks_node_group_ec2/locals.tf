locals {
  default_ingress_ports = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    },
    {
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
    }
  ]

  default_egress_ports = [
    {
      # Kubelet
      from_port   = 10250
      to_port     = 10250
      protocol    = "tcp"
      cidr_blocks = [var.cidr_block]
    },
    {
      # Allow all outbound traffic
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  # Merge default values with user-provided values
  merged_ingress_ports = distinct(concat(local.default_ingress_ports, tolist(var.ingress_ports)))
  merged_egress_ports  = distinct(concat(local.default_egress_ports, tolist(var.egress_ports)))
}
