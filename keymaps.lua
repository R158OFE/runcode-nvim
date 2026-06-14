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

  -- 3. Điều hướng cửa sổ: Nếu có rồi thì nhảy vào, chưa có thì split
  if term_win then
    vim.api.nvim_set_current_win(term_win)
  else
    vim.cmd("split") -- Chỉ chẻ đôi màn hình nếu chưa có terminal nào mở
  end

  -- 4. Kiểm tra ngôn ngữ và chạy lệnh tương ứng với Windows
  if ft == "python" then
    vim.cmd("term python " .. file)
    vim.cmd("startinsert")

  elseif ft == "javascript" then
    vim.cmd("term node " .. file)
    vim.cmd("startinsert")

  elseif ft == "cpp" then
    -- Cấu hình chuẩn cho Windows: dùng .exe và chạy bằng tên file
    vim.cmd("term g++ " .. file .. " -o " .. name .. ".exe && " .. name .. ".exe")
    vim.cmd("startinsert")

  elseif ft == "c" then
    -- Cấu hình chuẩn cho Windows: dùng .exe và chạy bằng tên file
    vim.cmd("term gcc " .. file .. " -o " .. name .. ".exe && " .. name .. ".exe")
    vim.cmd("startinsert")

  else
    print("Unsupported filetype: " .. ft)
  end
end, { desc = "Run current file intelligently" })