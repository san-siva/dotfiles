local Module = {}

Module.size_threshold = 1024 * 1024

---Check if a file is large based on its size
---@param filepath string The path to the file to check
---@param threshold? number Optional size threshold in bytes (defaults to 1MB)
---@return boolean is_large True if file size exceeds threshold
---@return number|nil size File size in bytes, or nil if file doesn't exist
function Module.is_large_file(filepath, threshold)
  threshold = threshold or Module.size_threshold

  local stat = vim.loop.fs_stat(filepath)
  if not stat then
    return false, nil
  end

  local size = stat.size
  return size > threshold, size
end

---Format file size to human-readable format
---@param size number Size in bytes
---@return string formatted Formatted size string (e.g., "1.5 MB")
function Module.format_size(size)
  local units = { "B", "KB", "MB", "GB", "TB" }
  local unit_index = 1
  local size_float = size

  while size_float >= 1024 and unit_index < #units do
    size_float = size_float / 1024
    unit_index = unit_index + 1
  end

  return string.format("%.2f %s", size_float, units[unit_index])
end

---Check if current buffer's file is large
---@param threshold? number Optional size threshold in bytes
---@return boolean is_large True if current buffer's file exceeds threshold
---@return number|nil size File size in bytes, or nil if no file
function Module.is_current_buffer_large(threshold)
  local filepath = vim.api.nvim_buf_get_name(0)
  if filepath == "" then
    return false, nil
  end

  return Module.is_large_file(filepath, threshold)
end

return Module
