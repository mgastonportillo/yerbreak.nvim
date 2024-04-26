# 🧉 Yerbreak

> Make a pause, take a deep breath and drink some mates. Now you're ready to get back to work.

## Installation
Lazy:
```lua
{
    "mgastonportillo/yerbreak.nvim",
    event = "VeryLazy",
    config = function()
        require("yerbreak").setup()
    end
}
```
## Configuration
Defaults:
```lua
require("yerbreak").setup({
    ascii_table =  "op" -- "mate" | "op", though "mate" doesn't work just yet
    delay = 5000, -- integer (ms)
    border = "rounded", -- "rounded" | "single" | "none" | "double" | "solid" | "shadow"
})
```

## Commands

`:Yerbreak` Toggle Yerbreak on/off
