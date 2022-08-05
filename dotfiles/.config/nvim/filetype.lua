vim.filetype.add({
  extension = {
    norg = "norg",
  },
  filename = {
    ["Brewfile"] = "ruby",
    ["flake8"] = "dosini",
    ["pycodestyle"] = "dosini",
  },
  pattern = {
    [".gitconfig.*"] = "gitconfig",
  }
})
