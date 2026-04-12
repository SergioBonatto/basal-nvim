# basal.vim

`basal.vim` is a minimalist personal knowledge management (PKM) framework for Vim. It implements a file-based Digital Brain using the P.A.R.A. (Projects, Areas, Resources, Archives) methodology, leveraging `ripgrep` and `fzf` for high-performance indexing and navigation.

## Prerequisites

The following tools must be installed and available in your `PATH`:

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

After installation, define the root directory for your brain in your `.vimrc` (optional) and run the initialization command:

```vim
let g:basal_path = '~/brain'
```

Execute within Vim:
```vim
:BasalInit
```

This command scaffolds the P.A.R.A. directory structure and populates the root with system files (`index.md`, `meta.md`, `inbox.md`, etc.) from the plugin's skeleton.

## Directory Structure

The system follows a strict hierarchical organization:

* `0_Projects/`: Active projects with a defined deadline.
* `1_Areas/`: Ongoing responsibilities requiring a standard of performance.
* `2_Resources/`: Interests and reference material.
* `3_Archives/`: Completed or inactive items.
* `4_Templates/`: Markdown boilerplate for notes and projects.
* `5_Daily/`: Chronological activity logs (ISO 8601 format).

## Usage

### Navigation

The plugin utilizes Vim's `path` and `suffixesadd` to enable seamless navigation:
* Place the cursor over a file link like `[2_Resources/linux-kernel]` and press `gf` to open it.
* Press `F` over any `#Tag` to execute a global search for that specific tag across the entire database.

### Default Mappings

If `g:basal_disable_mappings` is not set to 1, the following mappings are active:

| Mapping | Action |
| :--- | :--- |
| `<leader>bb` | Open Index (`index.md`) |
| `<leader>bt` | Open TODO list (`TODO.md`) |
| `<leader>bd` | Open/Create Daily Log for current date |
| `<leader>bs` | Interactive global search via `:BasalSearch` |
| `F` | Search for `#Tag` or word under cursor |

## Configuration

| Variable | Description | Default |
| :--- | :--- | :--- |
| `g:basal_path` | Absolute path to the database root | `~/basal-brain` |
| `g:basal_disable_mappings` | Disables the default keyboard mappings | `0` |

## Technical Implementation

* **Search Engine**: Uses `rg` with `--column`, `--line-number`, and `--smart-case`. Tag searches are automatically suffixed with word boundaries (`\b`) to prevent partial matches.
* **Autoload**: Core functions are located in `autoload/`, ensuring zero impact on Vim's startup time.
* **Environment**: Sets a `$BASAL` environment variable within the Vim process for easy access in custom scripts or shell escapes.

