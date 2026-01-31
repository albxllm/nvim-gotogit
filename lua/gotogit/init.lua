-- gotogit.nvim - Open current line in browser
local M = {}

local function cmd(args, cwd)
  local out = vim.fn.systemlist(args, nil, cwd)
  return vim.v.shell_error == 0 and out[1] or nil
end

local function get_remote_url(cwd)
  local url = cmd({ "git", "-C", cwd, "remote", "get-url", "origin" })
  if not url then return nil end
  url = url:gsub("^git@([^:]+):", "https://%1/")
  url = url:gsub("%.git$", "")
  return url
end

local function get_root(cwd)
  return cmd({ "git", "-C", cwd, "rev-parse", "--show-toplevel" })
end

local function get_commit(cwd)
  return cmd({ "git", "-C", cwd, "rev-parse", "HEAD" })
end

function M.open()
  local file = vim.fn.expand("%:p")
  local cwd = vim.fn.fnamemodify(file, ":h")
  
  local root = get_root(cwd)
  if not root then return end
  
  local remote = get_remote_url(cwd)
  if not remote then return end
  
  local rel_path = file:sub(#root + 2)
  local ref = get_commit(cwd) or "main"
  
  local start_line, end_line
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    start_line = vim.fn.line("'<")
    end_line = vim.fn.line("'>")
  else
    start_line = vim.fn.line(".")
    end_line = start_line
  end
  
  local url
  if remote:match("gitlab%.com") then
    url = string.format("%s/-/blob/%s/%s#L%d", remote, ref, rel_path, start_line)
    if end_line ~= start_line then
      url = url .. "-" .. end_line
    end
  else
    -- GitHub (default)
    url = string.format("%s/blob/%s/%s#L%d", remote, ref, rel_path, start_line)
    if end_line ~= start_line then
      url = url .. "-L" .. end_line
    end
  end
  
  local is_mac = vim.fn.has("mac") == 1
  if is_mac then
    vim.fn.jobstart({ "open", url }, { detach = true })
  else
    local browser = os.getenv("BROWSER") or "xdg-open"
    vim.fn.jobstart({ browser, url }, { detach = true })
  end
end

function M.setup(opts)
  opts = opts or {}
  local key = opts.keymap or "<leader>gg"
  
  if key then
    vim.keymap.set({ "n", "v" }, key, M.open, { desc = "Open line in git remote" })
  end
  
  vim.api.nvim_create_user_command("GotoGit", M.open, { range = true })
end

return M
