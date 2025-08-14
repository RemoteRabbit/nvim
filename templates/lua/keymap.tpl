;; lua
-- {{_file_name_}} - {{_input_:keymap_description_}} keymaps
-- Author: {{_author_}}
-- Date: {{_date_}}

local M = {}

-- Helper function for setting keymaps with consistent options
local function map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then
    options = vim.tbl_extend("force", options, opts)
  end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Leader key mappings
M.leader_maps = {
  -- {{_input_:category_name_}} mappings
  ["{{_input_:leader_key_1_}}"] = {
    name = "{{_input_:category_name_}}",
    ["{{_input_:sub_key_1_}}"] = { "{{_input_:command_1_}}", "{{_input_:description_1_}}" },
    ["{{_input_:sub_key_2_}}"] = { "{{_input_:command_2_}}", "{{_input_:description_2_}}" },
    ["{{_input_:sub_key_3_}}"] = {
      function()
        {{_cursor_}}
      end,
      "{{_input_:description_3_}}"
    },
  },
}

-- Normal mode mappings
M.normal_maps = {
  ["{{_input_:normal_key_1_}}"] = { "{{_input_:normal_command_1_}}", "{{_input_:normal_desc_1_}}" },
  ["{{_input_:normal_key_2_}}"] = { "{{_input_:normal_command_2_}}", "{{_input_:normal_desc_2_}}" },
}

-- Visual mode mappings
M.visual_maps = {
  ["{{_input_:visual_key_1_}}"] = { "{{_input_:visual_command_1_}}", "{{_input_:visual_desc_1_}}" },
  ["{{_input_:visual_key_2_}}"] = { "{{_input_:visual_command_2_}}", "{{_input_:visual_desc_2_}}" },
}

-- Insert mode mappings
M.insert_maps = {
  ["{{_input_:insert_key_1_}}"] = { "{{_input_:insert_command_1_}}", "{{_input_:insert_desc_1_}}" },
  ["{{_input_:insert_key_2_}}"] = { "{{_input_:insert_command_2_}}", "{{_input_:insert_desc_2_}}" },
}

-- Buffer-local mappings (for specific filetypes)
M.buffer_maps = {
  ["{{_input_:filetype_}}"] = {
    normal = {
      ["{{_input_:ft_key_1_}}"] = { "{{_input_:ft_command_1_}}", "{{_input_:ft_desc_1_}}" },
      ["{{_input_:ft_key_2_}}"] = { "{{_input_:ft_command_2_}}", "{{_input_:ft_desc_2_}}" },
    },
    insert = {
      ["{{_input_:ft_insert_key_}}"] = { "{{_input_:ft_insert_command_}}", "{{_input_:ft_insert_desc_}}" },
    },
  },
}

-- Set up all keymaps
function M.setup()
  -- Set up leader key mappings
  for leader_key, mappings in pairs(M.leader_maps) do
    for sub_key, mapping in pairs(mappings) do
      if sub_key ~= "name" then
        local full_key = "<leader>" .. leader_key .. sub_key
        map("n", full_key, mapping[1], { desc = mapping[2] })
      end
    end
  end

  -- Set up normal mode mappings
  for key, mapping in pairs(M.normal_maps) do
    map("n", key, mapping[1], { desc = mapping[2] })
  end

  -- Set up visual mode mappings
  for key, mapping in pairs(M.visual_maps) do
    map("v", key, mapping[1], { desc = mapping[2] })
  end

  -- Set up insert mode mappings
  for key, mapping in pairs(M.insert_maps) do
    map("i", key, mapping[1], { desc = mapping[2] })
  end

  -- Set up buffer-local mappings
  for filetype, modes in pairs(M.buffer_maps) do
    vim.api.nvim_create_autocmd("FileType", {
      pattern = filetype,
      callback = function()
        for mode, mappings in pairs(modes) do
          for key, mapping in pairs(mappings) do
            map(mode, key, mapping[1], { desc = mapping[2], buffer = true })
          end
        end
      end,
      desc = "Set up " .. filetype .. " specific keymaps",
    })
  end
end

-- Utility function to add a keymap
function M.add_keymap(mode, lhs, rhs, opts)
  map(mode, lhs, rhs, opts)
end

-- Utility function to remove a keymap
function M.remove_keymap(mode, lhs)
  vim.keymap.del(mode, lhs)
end

return M
