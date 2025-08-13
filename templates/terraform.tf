# {{_file_name_}} - {{_cursor_}}
# Created: {{_date_}}

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

# Resources
resource "example" "main" {
  # Configuration here
}

# Outputs
output "example_output" {
  description = "Example output"
  value       = resource.example.main.id
}
