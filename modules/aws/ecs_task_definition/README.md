# ECS Task Definition Module

This Terraform module creates an Amazon ECS Task Definition, including IAM roles, a CloudWatch Log Group, and support for multiple containers with flexible configuration.

## Resources Created

- ECS Task Definition (`aws_ecs_task_definition`);
- IAM Roles:
  - Task Execution Role (with permissions to pull images and send logs);
  - Task Role (for runtime container permissions);
- IAM Policies (basic permissions for S3, CloudWatch, SSM);
- CloudWatch Log Group;

## Usage

```hcl
module "nginx_task_definition" {
  source = "./ecs_task_definition"

  name   = "nginx"
  region = "us-east-1"

  cpu    = "256"
  memory = "512"

  container_definitions = [
    {
      name      = "nginx"
      image     = "nginx:latest"
      cpu       = 256
      memory    = 512
      essential = true
      log_driver = "awslogs"
      environment = []
      port_mappings = [
        {
          container_port = 80
          host_port      = 80
          protocol       = "tcp"
        }
      ]
    }
  ]

  tags = {
    Project = "demo"
  }
}
```

## Variables

Variable | Type | Description | Default
|--|--|--|--|
name | string | Base name for all resources. | -
region | string | AWS region. | -
tags | map(string) | Common tags for all resources. | {}
cpu | string | Total CPU for the task. | -
memory | string | Total memory for the task (in MiB). | -
container_definitions | list(object) | List of container definitions (see example above). | -
network_mode | string | ECS network mode (bridge, host, awsvpc, etc.). | "awsvpc"
launch_type | set(string) | Launch types (FARGATE, EC2). | ["FARGATE"]
cpu_architecture | string | CPU architecture (X86_64 or ARM64). | "X86_64"
operating_system_family | string | Task operating system family (LINUX, etc.). | "LINUX"
log_retention_in_days | number | Retention period for logs in CloudWatch (in days). | 30
ephemeral_storage_size | number | Ephemeral storage in GiB (21–200). | 21

## Output Description

Output | Description
|--|--|
task_definition_arn | ARN of the ECS Task Definition.
task_role_arn | ARN of the Task Role.
execution_role_arn | ARN of the Execution Role.
cloudwatch_log_group | Name of the CloudWatch Log Group.