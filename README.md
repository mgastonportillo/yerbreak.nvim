# 🧉 Yerbreak

https://github.com/mgastonportillo/yerbreak.nvim/assets/106234166/fd992095-2212-4e33-bbd6-c5afd4049463

> Make a pause, take a deep breath and drink some mates. Now you're ready to get back to work.

## Installation
Lazy:
```lua
{
  "mgastonportillo/yerbreak.nvim",
  dependencies = { "rcarriga/nvim-notify" }, -- optional: custom notifications
  event = "VeryLazy",
  init = function()
    -- any mappings should go here
  end
  opts = {}, -- or config = true
}
```
## Configuration
Defaults:
```lua
opts = {
  ascii_table = "mate" -- "mate" | "op"
  delay = 200, -- integer (ms)
  border = "rounded", -- "rounded" | "single" | "none" | "double" | "solid" | "shadow"
}
```

## Commands

`:Yerbreak` Toggle Yerbreak on/off

## Credits
`@MaximilianLloyd` for the One Piece ascii tables
