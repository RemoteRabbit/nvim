-- File templates for different languages
return {
  {
    -- Template system
    "glepnir/template.nvim",
    config = function()
      require("template").setup({
        temp_dir = "~/.config/nvim/templates",
        author = "Your Name",
        email = "your.email@example.com",
      })

      -- Create template directory and files
      local template_dir = vim.fn.expand("~/.config/nvim/templates")
      if vim.fn.isdirectory(template_dir) == 0 then
        vim.fn.mkdir(template_dir, "p")
      end

      -- Template contents
      local templates = {
        ["python.py"] = [[#!/usr/bin/env python3
"""
{{_file_name_}} - {{_cursor_}}

Author: {{_author_}}
Date: {{_date_}}
"""

def main():
    """Main function."""
    pass


if __name__ == "__main__":
    main()
]],
        ["go.go"] = [[package {{_input_:package_name_}}

import (
    "fmt"
)

func main() {
    fmt.Println("{{_cursor_}}")
}
]],
        ["terraform.tf"] = [[# {{_file_name_}} - {{_cursor_}}
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
]],
        ["elixir.ex"] = [[defmodule {{_input_:module_name_}} do
  @moduledoc """
  {{_cursor_}}
  
  Author: {{_author_}}
  Date: {{_date_}}
  """

  def hello do
    :world
  end
end
]],
        ["json.json"] = [[{
  "name": "{{_input_:name_}}",
  "version": "1.0.0",
  "description": "{{_cursor_}}",
  "main": "index.js",
  "scripts": {
    "start": "node index.js"
  },
  "keywords": [],
  "author": "{{_author_}}",
  "license": "MIT"
}
]],
        ["yaml.yml"] = [[# {{_file_name_}} - {{_cursor_}}
# Created: {{_date_}}

apiVersion: v1
kind: ConfigMap
metadata:
  name: {{_input_:config_name_}}
  namespace: default
data:
  key: value
]],
        ["bash.sh"] = [[#!/bin/bash
# {{_file_name_}} - {{_cursor_}}
# Author: {{_author_}}
# Date: {{_date_}}

set -euo pipefail

main() {
    echo "Hello, World!"
}

main "$@"
]],
        ["lua.lua"] = [[-- {{_file_name_}} - {{_cursor_}}
-- Author: {{_author_}}
-- Date: {{_date_}}

local M = {}

function M.setup(opts)
  opts = opts or {}
  -- Setup code here
end

return M
]],
        ["markdown.md"] = [[# {{_input_:title_}}

**Author:** {{_author_}}  
**Date:** {{_date_}}

## Overview

{{_cursor_}}

## Usage

## Examples

## Notes
]],
      }

      -- Write template files
      for filename, content in pairs(templates) do
        local filepath = template_dir .. "/" .. filename
        local file = io.open(filepath, "w")
        if file then
          file:write(content)
          file:close()
        end
      end
    end,
  },
  {
    -- Enhanced file creation
    "otavioschwanck/new-file-template.nvim",
    config = function()
      require("new-file-template").setup({
        -- Remove the extension from the file name
        remove_extension = false,
        -- Use the file name as the default for the `filename` placeholder
        use_as_default_filename = true,
        -- Default author
        default_author = "Your Name",
        -- Default email  
        default_email = "your.email@example.com",
        -- Custom templates
        templates = {
          {
            pattern = "*.py",
            content = {
              "#!/usr/bin/env python3",
              '"""',
              "{{filename}} - {{cursor}}",
              "",
              "Author: {{author}}",
              "Date: {{date}}",
              '"""',
              "",
              "",
              "def main():",
              '    """Main function."""',
              "    pass",
              "",
              "",
              'if __name__ == "__main__":',
              "    main()",
            },
          },
          {
            pattern = "*.go",
            content = {
              "package main",
              "",
              "import (",
              '    "fmt"',
              ")",
              "",
              "func main() {",
              '    fmt.Println("{{cursor}}")',
              "}",
            },
          },
          {
            pattern = "*.tf",
            content = {
              "# {{filename}} - {{cursor}}",
              "# Created: {{date}}",
              "",
              "terraform {",
              "  required_version = \">= 1.0\"",
              "  required_providers {",
              "    aws = {",
              '      source  = "hashicorp/aws"',
              '      version = "~> 5.0"',
              "    }",
              "  }",
              "}",
              "",
              "# Variables",
              'variable "environment" {',
              '  description = "Environment name"',
              "  type        = string",
              '  default     = "dev"',
              "}",
            },
          },
        },
      })
    end,
  },
}
