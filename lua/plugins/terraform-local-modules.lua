return {
  "nvim-lua/plenary.nvim",
  ft = "terraform",
  config = function()
    -- Find all variable files in a directory (including nested)
    local function find_variable_files(dir)
      local var_files = {}
      local possible_names = { "variables.tf", "vars.tf", "variable.tf" }

      -- Check direct directory
      for _, name in ipairs(possible_names) do
        local file = dir .. "/" .. name
        if vim.fn.filereadable(file) == 1 then
          table.insert(var_files, file)
        end
      end

      -- Check nested modules directory
      local modules_dir = dir .. "/modules"
      if vim.fn.isdirectory(modules_dir) == 1 then
        local nested_modules = vim.fn.glob(modules_dir .. "/*", false, true)
        for _, nested_path in ipairs(nested_modules) do
          if vim.fn.isdirectory(nested_path) == 1 then
            for _, name in ipairs(possible_names) do
              local file = nested_path .. "/" .. name
              if vim.fn.filereadable(file) == 1 then
                table.insert(var_files, file)
              end
            end
          end
        end
      end

      return var_files
    end

    -- Parse variables from a variables.tf file
    local function parse_variables_from_file(variables_file)
      if vim.fn.filereadable(variables_file) == 0 then
        return {}
      end

      local content = table.concat(vim.fn.readfile(variables_file), "\n")
      local variables = {}

      -- Better regex to match variable blocks with proper brace handling
      local i = 1
      while i <= #content do
        local var_start, var_end, var_name = content:find('variable%s+"([^"]+)"%s*{', i)
        if not var_start then
          break
        end

        -- Find the matching closing brace
        local brace_count = 1
        local j = var_end + 1
        while j <= #content and brace_count > 0 do
          local char = content:sub(j, j)
          if char == "{" then
            brace_count = brace_count + 1
          elseif char == "}" then
            brace_count = brace_count - 1
          end
          j = j + 1
        end

        if brace_count == 0 then
          local var_content = content:sub(var_end + 1, j - 2)
          local has_default = var_content:match("default%s*=")
          local is_required = not has_default

          -- Extract description if available
          local description = var_content:match('description%s*=%s*"([^"]*)"') or ""

          -- Extract type information
          local type_info = var_content:match("type%s*=%s*([^\n]+)") or "any"
          type_info = type_info:gsub("%s+$", "") -- trim trailing whitespace

          -- Extract default value for optional variables
          local default_value = ""
          if has_default then
            local default_match = var_content:match("default%s*=%s*([^\n]+)")
            if default_match then
              default_value = default_match:gsub("%s+$", "") -- trim trailing whitespace
              -- Truncate long defaults
              if #default_value > 50 then
                default_value = default_value:sub(1, 47) .. "..."
              end
            end
          end

          table.insert(variables, {
            name = var_name,
            required = is_required,
            description = description,
            type = type_info,
            default = default_value,
          })
        end

        i = j
      end

      return variables
    end

    -- Parse all variables from a module directory
    local function parse_variables(module_dir)
      local all_variables = {}
      local var_files = find_variable_files(module_dir)

      for _, file in ipairs(var_files) do
        local file_vars = parse_variables_from_file(file)
        for _, var in ipairs(file_vars) do
          table.insert(all_variables, var)
        end
      end

      return all_variables
    end

    -- Function to parse .terraform/modules/modules.json
    local function parse_terraform_modules()
      local modules_json = "./.terraform/modules/modules.json"
      if vim.fn.filereadable(modules_json) == 0 then
        return {}
      end

      local content = table.concat(vim.fn.readfile(modules_json), "")
      local ok, data = pcall(vim.json.decode, content)
      if not ok then
        print("Failed to parse modules.json")
        return {}
      end

      local modules = {}
      if data.Modules then
        for _, module in ipairs(data.Modules) do
          if module.Key ~= "" then -- Skip root module
            -- Dir field might already include .terraform/modules/ prefix
            local module_dir = module.Dir
            if not module_dir:match("^%.terraform/modules/") then
              module_dir = "./.terraform/modules/" .. module_dir
            else
              module_dir = "./" .. module_dir
            end

            local variables = parse_variables(module_dir)

            table.insert(modules, {
              name = module.Key,
              source = module.Source,
              dir = module_dir,
              variables = variables,
            })
          end
        end
      end

      return modules
    end

    -- Function to get unique module sources
    local function get_unique_modules()
      local unique_modules = {}
      local seen_sources = {}

      -- First, get downloaded modules from modules.json (group by source)
      local terraform_modules = parse_terraform_modules()
      for _, module in ipairs(terraform_modules) do
        if not seen_sources[module.source] then
          seen_sources[module.source] = true

          -- Extract module name from source
          local display_name = module.source
          if module.source:match("^%.*/(.+)$") then
            display_name = module.source:match("^%.*/(.+)$")
          elseif module.source:match("([^/]+)$") then
            display_name = module.source:match("([^/]+)$")
          end

          table.insert(unique_modules, {
            name = display_name,
            source = module.source,
            dir = module.dir,
            variables = module.variables,
            type = "downloaded",
          })
        end
      end

      -- Then, get local modules
      local local_paths = {
        "./modules",
        "../modules",
        "../../modules",
        "./terraform-modules",
        "../terraform-modules",
      }

      for _, path in ipairs(local_paths) do
        local result = vim.fn.glob(path .. "/*", false, true)
        for _, module_path in ipairs(result) do
          if vim.fn.isdirectory(module_path) == 1 then
            local module_name = vim.fn.fnamemodify(module_path, ":t")
            local relative_path = vim.fn.fnamemodify(module_path, ":.")
            local variables = parse_variables(module_path)

            if not seen_sources[relative_path] then
              seen_sources[relative_path] = true

              table.insert(unique_modules, {
                name = module_name,
                source = relative_path,
                dir = module_path,
                variables = variables,
                type = "local",
              })
            end
          end
        end
      end

      return unique_modules
    end

    -- Create command to show available modules
    vim.api.nvim_create_user_command("TerraformShowModules", function()
      get_unique_modules()
    end, {
      desc = "Show discovered Terraform modules",
    })

    -- Simple keymap to insert module template
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "terraform",
      callback = function()
        vim.keymap.set("n", "<leader>tm", function()
          local modules = get_unique_modules()
          if #modules > 0 then
            vim.ui.select(modules, {
              prompt = "Select module source:",
              format_item = function(item)
                local req_count = 0
                for _, var in ipairs(item.variables) do
                  if var.required then
                    req_count = req_count + 1
                  end
                end
                local opt_count = #item.variables - req_count
                -- Truncate long source paths to keep selection readable
                local source = item.source
                if #source > 60 then
                  source = "..." .. source:sub(-57)
                end
                return string.format(
                  "[%s] %s (%d req, %d opt) - %s",
                  item.type,
                  item.name,
                  req_count,
                  opt_count,
                  source
                )
              end,
            }, function(choice)
              if choice then
                -- Prompt for module name first
                vim.ui.input({
                  prompt = "Module name: ",
                }, function(module_name)
                  if not module_name or module_name == "" then
                    return
                  end

                  -- Separate required and optional variables
                  local required_vars = {}
                  for _, var in ipairs(choice.variables) do
                    if var.required then
                      table.insert(required_vars, var)
                    end
                  end

                  -- Function to format value based on type
                  local function format_value(value, var_type)
                    if not value or value == "" then
                      return '""' -- default to empty string
                    end

                    -- Clean up type (remove extra whitespace, etc.)
                    local clean_type = var_type:gsub("%s+", ""):lower()

                    -- Handle different types
                    if clean_type:match("^string") then
                      -- String type - add quotes if not already quoted
                      if not value:match('^".*"$') then
                        return '"' .. value .. '"'
                      end
                      return value
                    elseif clean_type:match("^number") or clean_type:match("^int") then
                      -- Number type - no quotes
                      return value
                    elseif clean_type:match("^bool") then
                      -- Boolean type - ensure it's true/false
                      local lower_val = value:lower()
                      if lower_val == "true" or lower_val == "yes" or lower_val == "1" then
                        return "true"
                      elseif lower_val == "false" or lower_val == "no" or lower_val == "0" then
                        return "false"
                      end
                      return value -- let user handle complex cases
                    elseif clean_type:match("^list") then
                      -- List type - add brackets if not present
                      if not value:match("^%[.*%]$") then
                        return "[" .. value .. "]"
                      end
                      return value
                    elseif clean_type:match("^map") or clean_type:match("^object") then
                      -- Map/object type - add braces if not present
                      if not value:match("^{.*}$") then
                        return "{" .. value .. "}"
                      end
                      return value
                    else
                      -- Unknown or 'any' type - return as-is
                      return value
                    end
                  end

                  -- Collect values for required variables
                  local var_values = {}
                  local function collect_var(index)
                    if index > #required_vars then
                      -- All variables collected, generate template
                      local lines = {}
                      table.insert(lines, 'module "' .. module_name .. '" {')
                      table.insert(lines, '  source = "' .. choice.source .. '"')
                      table.insert(lines, "")

                      if #required_vars > 0 then
                        table.insert(lines, "  # Required variables:")
                        for i, var in ipairs(required_vars) do
                          local formatted_value = format_value(var_values[i], var.type)
                          table.insert(lines, "  " .. var.name .. " = " .. formatted_value)
                        end
                        table.insert(lines, "")
                      end

                      -- Optional variables (commented)
                      local optional_vars = {}
                      for _, var in ipairs(choice.variables) do
                        if not var.required then
                          table.insert(optional_vars, var)
                        end
                      end

                      if #optional_vars > 0 then
                        table.insert(lines, "  # Optional variables:")
                        for _, var in ipairs(optional_vars) do
                          local comment = ""
                          if var.default ~= "" then
                            comment = string.format(" # default: %s", var.default)
                          end
                          if var.description ~= "" then
                            local desc = var.description
                            -- Truncate long descriptions to prevent very long lines
                            if #desc > 50 then
                              desc = desc:sub(1, 47) .. "..."
                            end
                            comment = comment .. (comment ~= "" and " - " or " # ") .. desc
                          end

                          local line = "  # " .. var.name .. " = " .. comment
                          -- If line would be too long, break it up
                          if #line > 120 then
                            table.insert(lines, "  # " .. var.name .. " = ")
                            table.insert(lines, "  #   " .. comment:gsub("^# ", ""))
                          else
                            table.insert(lines, line)
                          end
                        end
                      end

                      table.insert(lines, "}")
                      vim.api.nvim_put(lines, "l", true, true)
                      return
                    end

                    -- Prompt for current variable
                    local var = required_vars[index]
                    local prompt = var.name
                    if var.type ~= "any" then
                      -- Truncate very long types
                      local var_type = var.type
                      if #var_type > 30 then
                        var_type = var_type:sub(1, 27) .. "..."
                      end
                      prompt = prompt .. " (" .. var_type .. ")"
                    end
                    if var.description ~= "" then
                      -- Truncate long descriptions to keep prompt reasonable
                      local desc = var.description
                      if #desc > 60 then
                        desc = desc:sub(1, 57) .. "..."
                      end
                      prompt = prompt .. " - " .. desc
                    end
                    prompt = prompt .. ": "

                    -- Provide suggestions for common variable names
                    local default_value = ""
                    if var.name:match("region") and var.type:match("string") then
                      default_value = "us-east-1"
                    elseif var.name:match("environment") and var.type:match("string") then
                      default_value = "dev"
                    elseif var.name:match("enabled") and var.type:match("bool") then
                      default_value = "true"
                    end

                    vim.ui.input({
                      prompt = prompt .. " (or 'back' to go back)",
                      default = default_value,
                    }, function(value)
                      if value == "back" and index > 1 then
                        collect_var(index - 1) -- go back to previous variable
                      elseif value and value ~= "" and value ~= "back" then
                        var_values[index] = value
                        collect_var(index + 1)
                      else
                        var_values[index] = '""' -- default empty string
                        collect_var(index + 1)
                      end
                    end)
                  end

                  collect_var(1)
                end)
              end
            end)
          else
            print("No modules found in current directory")
          end
        end, { buffer = true, desc = "Insert Module Template" })
      end,
    })
  end,
}
