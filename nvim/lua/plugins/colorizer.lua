local colorizer_status, colorizer = pcall(require, 'colorizer')
if not colorizer_status then
	vim.notify('Colorizer not found', vim.log.levels.ERROR)
	return
end

colorizer.setup()
