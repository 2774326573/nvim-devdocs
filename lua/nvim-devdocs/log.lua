local uv = vim.uv or vim.loop
local M = {}

local data_dir = vim.fn.stdpath("data")
local log_dir = data_dir .. "/devdocs"

local function ensure_dir(path)
  if uv then
    local stat = uv.fs_stat(path)
    if stat and stat.type == "directory" then
      return
    end
  end
  vim.fn.mkdir(path, "p")
end

ensure_dir(log_dir)

local log = require("plenary.log").new({
  plugin = "nvim-devdocs",
  use_console = false, -- use vim.notify instead
  outfile = log_dir .. "/log.txt",
  fmt_msg = function(_, mode_name, src_path, src_line, message)
    local mode = mode_name:upper()
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local source = vim.fn.fnamemodify(src_path, ":t") .. ":" .. src_line

    return string.format("[%s][%s] %s: %s\n", mode, timestamp, source, message)
  end,
}, false)

local notify = vim.schedule_wrap(
  function(message, level) vim.notify("[nvim-devdocs] " .. message, level) end
)

M.debug = function(message)
  notify(message, vim.log.levels.DEBUG)
  log.debug(message)
end

M.info = function(message)
  notify(message, vim.log.levels.INFO)
  log.info(message)
end

M.warn = function(message)
  notify(message, vim.log.levels.WARN)
  log.warn(message)
end

M.error = function(message)
  notify(message, vim.log.levels.ERROR)
  log.error(message)
end

return M
