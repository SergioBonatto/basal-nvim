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

This command creates the target directory, scaffolds the P.A.R.A. structure, and populates the root with system files (`index.md`, `meta.md`, `inbox.md`, `TODO.md`, etc.) from the plugin skeleton.

## Directory Structure

The system organizes information into the following hierarchy:

* `0_Projects/`: Active projects with defined objectives and deadlines.
* `1_Areas/`: Ongoing responsibilities requiring a standard of performance.
* `2_Resources/`: Knowledge library and reference material.
* `3_Archives/`: Completed or inactive items for cold storage.
* `4_Templates/`: Markdown boilerplate for notes and projects.
* `5_Daily/`: Chronological activity logs.

## Usage

### Navigation and Linking

The plugin configures Vim's `path` and `suffixesadd` to facilitate seamless navigation:
* **File Links**: Use `gf` (go to file) over Markdown links like `[[note-name]]` or `[description](path/to/file.md)` to open the target.
* **Global Search**: Press `F` over any word or `#tag` to execute a global search across the entire database.

### Commands

| Command | Description |
| :--- | :--- |
| `:BasalInit` | Initializes the brain structure in `g:basal_path`. |
| `:BasalSearch [query]` | Performs a fuzzy search using `rg` within the brain directory. |

### Default Mappings

The following mappings are active unless `g:basal_disable_mappings` is set to 1:

| Mapping | Action |
| :--- | :--- |
| `<leader>bb` | Open Index (`index.md`) |
| `<leader>bt` | Open TODO list (`TODO.md`) |
| `<leader>bd` | Open/Create Daily Log for the current date in `5_Daily/` |
| `<leader>bs` | Invoke `:BasalSearch` |
| `F` | Search for the word or `#tag` under the cursor |

## Configuration

| Variable | Description | Default |
| :--- | :--- | :--- |
| `g:basal_path` | Absolute path to the database root. Sets `$BASAL`. | `~/Basal` |
| `g:basal_disable_mappings` | Set to 1 to disable default keyboard mappings. | `0` |

## Technical Implementation

* **Search Engine**: Uses `rg` with `--column`, `--line-number`, and `--smart-case`. Querying for tags (starting with `#`) automatically enforces word boundaries (`\b`) to ensure precision.
* **Interface**: Integrates with `fzf#vim#grep` and `fzf#vim#with_preview` for an interactive search experience.
* **Environment**: Sets the `$BASAL` environment variable within the Vim process, allowing for easy integration with external scripts and shell commands.
* **Performance**: Core logic is implemented in `autoload/` to ensure minimal impact on Vim startup time.
