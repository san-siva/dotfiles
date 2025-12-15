local status, fidget = pcall(require, 'fidget')
if not status then
  vim.notify 'Problems with fidget'
  return
end

fidget.setup {
  progress = {
    suppress_on_insert = true,
    ignore_done_already = true,
  },
}
