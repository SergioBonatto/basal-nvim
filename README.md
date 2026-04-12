# basal.vim

`basal.vim` is a minimalist personal knowledge management (PKM) plugin for Vim. It implements a file-based Digital Brain using the P.A.R.A. (Projects, Areas, Resources, Archives) methodology, leveraging `ripgrep` and `fzf` for high-performance indexing and navigation.

## Prerequisites

The following tools must be installed and available in the system `PATH`:

* **Vim** or **Neovim**
* **ripgrep (rg)**: Required for global tag and content search.
* **fzf**: Required for the fuzzy-finding interface.
* **fzf.vim**: The Vim wrapper for fzf.

## Installation

Using `vim-plug`:

```vim
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'SergioBonatto/basal.vim'
```

## Initialization

Define the root directory for the brain in the `.vimrc` (optional) and execute the initialization command:

```vim
let g:basal_path = '~/Basal'
```

Execute within Vim:
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
Automatic syntax highlighting for `#tags` and `[[links]]` is applied to all files opened within the `$BASAL` directory.

## Commands

| Command | Description |
| :--- | :--- |
| `:BasalInit` | Initializes the brain structure. |
| `:BasalCheck` | Verifies dependencies (`rg`, `fzf`) and configuration. |
| `:BasalNew` | Creates a new note from a template via `fzf`. |
| `:BasalDaily` | Opens/creates the daily log for today. |
| `:BasalBacklinks`| Searches for files linking to the current note. |
| `:BasalSearch` | Performs a fuzzy search using `rg`. |

## Default Mappings

Active unless `g:basal_disable_mappings` is set to 1:

| Mapping | Action |
| :--- | :--- |
| `<leader>bb` | Open Index (`index.md`) |
| `<leader>bt` | Open TODO list (`TODO.md`) |
| `<leader>bd` | Open today's Daily Log |
| `<leader>bn` | Create a new note from template |
| `<leader>bs` | Interactive global search |
| `<leader>bl` | Show backlinks for current file |
| `F` | Search for the word or `#tag` under cursor |

## Configuration

| Variable | Description | Default |
| :--- | :--- | :--- |
| `g:basal_path` | Absolute path to the brain root. | `~/Basal` |
| `g:basal_disable_mappings`| Set to 1 to disable mappings. | `0` |
