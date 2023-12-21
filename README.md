# RemoteRabbit NeoVim setup

Currently using Lazy as my package manager

## Pull it

- Without my git

```shell
git clone https://github.com/remoterabbit/nvim $HOME/.config/nvim && rm -rf .git
```

- With my git

```shell
git clone https://github.com/remoterabbit/nvim $HOME/.config/nvim
```

- Link time version

```shell
git clone http://github.com/remoterabbit/nvim $HOME/repos/personal/nvim && ln -sf $HOME/repos/personal/nvim $HOME/.config
```

## What is each plugin

<table will go here>

## Mason Notes

[https://mason-registry.dev/registry/list](https://mason-registry.dev/registry/list)

## Which-key help

`<CR>` is often seen at the end of some mappings which is used like the `RETURN` or `ENTER` press

```lua
local wk = require("which-key")
-- As an example, we will create the following mappings:
--  * <leader>ff find files
--  * <leader>fr show recent files
--  * <leader>fb Foobar
-- we'll document:
--  * <leader>fn new file
--  * <leader>fe edit file
-- and hide <leader>1

wk.register({
  f = {
    name = "file", -- optional group name
    f = { "<cmd>Telescope find_files<cr>", "Find File" }, -- create a binding with label
    r = { "<cmd>Telescope oldfiles<cr>", "Open Recent File", noremap=false, buffer = 123 }, -- additional options for creating the keymap
    n = { "New File" }, -- just a label. don't create any mapping
    e = "Edit File", -- same as above
    ["1"] = "which_key_ignore",  -- special label to hide it in the popup
    b = { function() print("bar") end, "Foobar" } -- you can also pass functions!
  },
}, { prefix = "<leader>" })
```
