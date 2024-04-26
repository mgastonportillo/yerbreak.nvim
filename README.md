# 🧉 Yerbreak

![Yerbreak](https://github.com/mgastonportillo/yerbreak.nvim/assets/106234166/a7ec01ed-57b4-4b5f-9f58-4c8ebc1b19fd)

> Make a pause, take a deep breath and drink some mates. Now you're ready to get back to work.

## Installation
Lazy:
```lua
{
  "mgastonportillo/yerbreak.nvim",
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
  delay = 5000, -- integer (ms)
  border = "rounded", -- "rounded" | "single" | "none" | "double" | "solid" | "shadow"
}
```

## Commands

`:Yerbreak` Toggle Yerbreak on/off
