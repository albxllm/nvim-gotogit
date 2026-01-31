# gitlink.nvim

Open current line in browser on GitHub/GitLab/Bitbucket. ~80 lines, no dependencies.

## Install

```lua
-- lazy.nvim
{ "albxllm/nvim-gitlink", config = true }

-- with options
{
  "albxllm/nvim-gitlink",
  config = function()
    require("gitlink").setup({ keymap = "<leader>gg" })
  end,
}
```

## Usage

- `<leader>gg` — open current line in browser
- Visual select + `<leader>gg` — open line range
- `:GitLink` — command form

## Features

- GitHub, GitLab, Bitbucket support
- Uses commit SHA for stable permalinks
- Visual mode for line ranges
- Respects `$BROWSER` env var
- Fails silently if not a git repo
