# 🧉 Yerbreak

https://github.com/mgastonportillo/yerbreak.nvim/assets/106234166/3810a70e-e428-4af7-bd15-b0963e89ea10

> Make a pause, take a deep breath and drink some mates. Now you're ready to get back to work.

## Installation
Lazy:
```lua
{
  "mgastonportillo/yerbreak.nvim",
  dependencies = { "rcarriga/nvim-notify" }, -- optional: custom notifications
  event = "VeryLazy",
  config = function(_ opts)
    require("yerbreak").setup(opts)
  end
}
```
## Configuration
Defaults:
```lua
opts = {
  ascii_table = "mate" -- "mate" | "op"
  delay = 500, -- integer (ms)
  border = "rounded", -- "rounded" | "single" | "none" | "double" | "solid" | "shadow"
}
```

## Commands

`:Yerbreak` Toggle Yerbreak on/off
