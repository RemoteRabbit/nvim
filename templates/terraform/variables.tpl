;; terraform
# {{_file_name_}} - Variable definitions

variable "{{_input_:var_name_}}" {
  description = "{{_input_:description_}}"
  type        = string
  default     = "{{_input_:default_value_}}"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
}

{{_cursor_}}
