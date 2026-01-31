# gotogit.nvim

Open current line in browser on GitHub/GitLab. ~60 lines, no dependencies.

## Install

```lua
{ "albxllm/nvim-gotogit", config = true }
```

## Usage

- `<leader>gg` — open current line in browser
- Visual select + `<leader>gg` — open line range
- `:GotoGit` — command form

Uses commit SHA for stable permalinks. Fails silently if not in a git repo.
