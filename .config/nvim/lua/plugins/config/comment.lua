local status, comment = pcall(require, "nvim_comment")
if (not status) then return end

comment.setup {
  marker_padding = true,
  line_mapping = "<Leader>cc",
  operator_mapping = "<Leader>c"
}
