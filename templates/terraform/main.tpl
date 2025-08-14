;; terraform
# {{_file_name_}} - Main infrastructure

locals {
  common_tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "{{_input_:resource_type_}}" "{{_input_:resource_name_}}" {
  {{_cursor_}}

  tags = local.common_tags
}
