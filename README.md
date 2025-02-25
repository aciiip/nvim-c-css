# Neovim Load CSS from external path

Neovim Custom CSS Intellisense

#### HTML id and class attribute completion for Neovim written in Lua.

## ✨ Features

- HTML `id` and `class` attribute completion.

## ⚡️ Requirements

- Neovim 0.10+

## 📦 Installation

### Lazy

```lua
return require("lazy").setup({
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "aciiip/nvim-c-css" -- add it as dependencies of `nvim-cmp` or standalone plugin
        },
        opts = {
            sources = {
                {
                    name = "c_css",
                    option = {
                        enable_on = { "html" }, -- html is enabled by default
                        notify = false,
                        documentation = {
                            auto_show = true, -- show documentation on select
                        },
                        path = ".custom_css", -- will retrieve all css files inside "yourproject/.custom_css" folder
                    },
                },
            },
        },
    },
})
```

## ⚙ Default Configuration

```lua
option = {
    enable_on = { "html" },
    notify = false,
    documentation = {
        auto_show = true,
    },
    path = ".c_css",
}
```

## 🤩 Pretty Menu Items

Setting the formatter this way, so you know from which file that class is coming.

```lua
require("cmp").setup({
    -- ...
    formatting = {
        format = function(entry, vim_item)
            local source = entry.source.name
            if source == "c_css" then
                vim_item.menu = "[" .. (entry.completion_item.provider or "C_CSS") .. "]"
            end
            return vim_item
        end
    }
    -- ...
})
```
