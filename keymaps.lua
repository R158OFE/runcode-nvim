-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<F5>", function()
  local ft = vim.bo.filetype
  local file = vim.fn.expand("%")
  local name = vim.fn.expand("%:r")

  -- 1. Tự động lưu file trước khi chạy
  vim.cmd("write")

  -- 2. Tìm xem đã có cửa sổ Terminal nào đang mở chưa
  local term_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].filetype == "terminal" then
      term_win = win
      break
    end
  end

  -- 3. Điều hướng cửa sổ
  if term_win then
    vim.api.nvim_set_current_win(term_win)
  else
    vim.cmd("split")
  end

  -- 4. Xử lý logic chạy file
  if ft == "python" then
    vim.cmd("term python " .. file)
  elseif ft == "javascript" then
    vim.cmd("term node " .. file)
  elseif ft == "cpp" then
    vim.cmd("term g++ " .. file .. " -o " .. name .. ".exe && " .. name .. ".exe")
  elseif ft == "c" then
    vim.cmd("term gcc " .. file .. " -o " .. name .. ".exe && " .. name .. ".exe")
  elseif ft == "cs" then
    -- Chạy bằng dotnet cho dự án C#
    vim.cmd("term dotnet run")
  elseif ft == "dosini" or file:match("%.exe$") then
    -- Nếu là file .exe thì gọi trực tiếp
    vim.cmd("term " .. file)
  else
    print("Unsupported filetype: " .. ft)
    return -- Dừng lại nếu không hỗ trợ
  end

  vim.cmd("startinsert")
end, { desc = "Run current file intelligently" })
