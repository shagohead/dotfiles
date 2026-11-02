vim.filetype.add({
  extension = {
		gotmpl = "gotmpl",
    norg = "norg",
  },
  filename = {
    ["Brewfile"] = "ruby",
    ["flake8"] = "dosini",
    ["pycodestyle"] = "dosini",
		[".gitlab-ci.yml"] = "yaml.gitlab",
		[".gitlab-ci.yaml"] = "yaml.gitlab",
  },
  pattern = {
    [".gitconfig.*"] = "gitconfig",
		["docker-compose*.yml"] = "yaml.docker-compose",
		["docker-compose*.yaml"] = "yaml.docker-compose",
  }
})
