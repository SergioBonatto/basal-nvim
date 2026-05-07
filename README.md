# basal-nvim

`basal-nvim` is a minimalist personal knowledge management (PKM) plugin for Neovim, rewritten in Lua. It implements a file-based Digital Brain using the P.A.R.A. (Projects, Areas, Resources, Archives) methodology, leveraging `ripgrep`, `fzf-lua`, and `nvim-treesitter` for high-performance indexing, navigation, and visual polish.

## Prerequisites

The following tools must be installed and available:

* **Neovim** (>= 0.8 recommended)
* **ripgrep (rg)**: Required for global tag and content search.
* **fzf-lua**: Required for the fuzzy-finding interface.
* **nvim-treesitter**: Required for advanced syntax highlighting.

## Installation

Using `lazy.nvim`:

```lua
{
  'SergioBonatto/basal-nvim',
  dependencies = {
    'ibhagwan/fzf-lua',
    'nvim-treesitter/nvim-treesitter',
  },
  config = function()
    require('basal').setup({
      path = '~/Basal', -- Optional: default is ~/Basal
    })
  end
}
```

## Initialization

Execute within Neovim:
```vim
:BasalInit
```

This command creates the target directory, scaffolds the P.A.R.A. structure, and populates the root with system files from the plugin skeleton.

## Directory Structure

* `0_Projects/`: Active projects with defined objectives.
* `1_Areas/`: Ongoing responsibilities.
* `2_Resources/`: Knowledge library and reference material.
* `3_Archives/`: Completed or inactive items.
* `4_Templates/`: Markdown boilerplate.
* `5_Daily/`: Chronological activity logs.

## Features

### Template Automation
Create new notes using templates located in `4_Templates/`.
- **Command**: `:BasalNew`
- **Placeholders**: The following strings are automatically replaced:
  - `YYYY-MM-DD`: Current ISO date.
  - `TITLE`: The filename/title of the note.

### Smart Daily Journaling
Quickly access your daily log. If it doesn't exist, it is created using `4_Templates/daily.md` (if available).
- **Command**: `:BasalDaily`
- **Mapping**: `<leader>bd`

### Navigation & Backlinks
- **File Links**: Use `gf` over `[[note-name]]` or `[text](path.md)` to follow links.
- **Backlinks**: Find all notes that link to the current buffer.
  - **Command**: `:BasalBacklinks`
  - **Mapping**: `<leader>bl`
- **Tag Search**: Press `F` over any `#tag` to execute a global search.

### Visual Polish
Advanced syntax highlighting for `#tags` and `[[links]]` is provided by Treesitter queries and applied to all files opened within the `$BASAL` directory.

## Commands

| Command | Description |
| :--- | :--- |
| `:BasalInit` | Initializes the brain structure. |
| `:BasalCheck` | Verifies dependencies (`rg`, `fzf-lua`) and configuration. |
| `:BasalNew` | Creates a new note from a template via `fzf-lua`. |
| `:BasalDaily` | Opens/creates the daily log for today. |
| `:BasalBacklinks`| Searches for files linking to the current note. |
| `:BasalSearch` | Performs a fuzzy search using `rg` and `fzf-lua`. |

## Default Mappings

Active unless `disable_mappings = true` is set in `setup()`:

| Mapping | Action |
| :--- | :--- |
| `<leader>bb` | Open Index (`index.md`) |
| `<leader>bt" | Open TODO list (`TODO.md`) |
| `<leader>bd` | Open today's Daily Log |
| `<leader>bn` | Create a new note from template |
| `<leader>bs` | Interactive global search |
| `<leader>bl` | Show backlinks for current file |
| `F` | Search for the word or `#tag` under cursor |

## Configuration

Default options:

```lua
require('basal').setup({
  path = vim.fn.expand("~/Basal"),
  disable_mappings = false,
  templates_dir = "4_Templates",
  notes_dir = "6_Notes",
  daily_dir = "5_Daily",
})
```
