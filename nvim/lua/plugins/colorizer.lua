local colorizer_status, colorizer = pcall(require, 'colorizer')
if not colorizer_status then
	vim.notify('Colorizer not found', vim.log.levels.ERROR)
	return
end

colorizer.setup()

-- Disable colorizer for large files
vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWinEnter' }, {
  group = vim.api.nvim_create_augroup('DisableColorizerForLargeFiles', { clear = true }),
  callback = function(args)
    if vim.b[args.buf].large_file then
      pcall(vim.cmd, 'ColorizerDetachFromBuffer')
    end
  end,
})
