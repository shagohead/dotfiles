-- https://github.com/glepnir/galaxyline.nvim
local galaxyline = require'galaxyline'
local section = galaxyline.section
galaxyline.short_line_list = {"packager"}

local buffer_not_empty = function()
  if vim.fn.empty(vim.fn.expand("%:t")) ~= 1 then
    return true
  end
  return false
end

local colors = {
  yellow = "#EBCB8B",
  cyan = "#A3BE8C",
  green = "#8FBCBB",
  orange = "#D08770",
  purple = "#B48EAD",
  blue = "#5E81AC",
  red = "#BF616A",
}

-- Отступ слева, равный signcolumn
section.left[1] = {
  FirstElement = {
    provider = function() return '   ' end,
  }
}
-- Иконка активного режима
--[[ section.left[2] = {
  ViMode = {
    provider = function()
      local mode_color = {
        n = 'Normal',
        i = colors.green,
        v = colors.blue,
        [""] = colors.blue,
        V = colors.blue,
        c = colors.red,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [""] = colors.orange,
        ic = colors.yellow,
        R = colors.purple,
        Rv = colors.purple,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ["r?"] = colors.cyan,
        ["!"] = colors.red,
        t = colors.red
      }
      vim.cmd("hi GalaxyViMode guifg=" .. mode_color[vim.fn.mode()])
      return "  "
    end,
  }
}
 ]]
-- Тип и имя файла
section.left[3] = {
  FileIcon = {
    provider = "FileIcon",
    condition = buffer_not_empty,
    highlight = {require("galaxyline.provider_fileinfo").get_file_icon_color}
  }
}
section.left[4] = {
  FileName = {
    provider = function() return vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.") end,
    condition = buffer_not_empty
  }
}

section.right[0] = {
  Keymap = {
    provider = function()
      if vim.opt.iminsert:get() == 1 then
        return "  "
      end
      return ""
    end,
    highlight = {"Cyan"}
  }
}

-- Текущая git ветка
section.right[1] = {
  GitIcon = {
    provider = function() return " " end,
    condition = require("galaxyline.provider_vcs").check_git_workspace,
    highlight = {colors.orange}
  }
}
section.right[2] = {
  GitBranch = {
    provider = "GitBranch",
    condition = require("galaxyline.provider_vcs").check_git_workspace,
  }
}

local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

signs = require'variables'.signs
-- Дифф изменений от gitgutter
section.right[3] = {
  DiffAdd = {
    provider = "DiffAdd",
    separator = " ",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.green}
  }
}
section.right[4] = {
  DiffModified = {
    provider = "DiffModified",
    condition = checkwidth,
    icon = "柳",
    highlight = {colors.yellow}
  }
}
section.right[5] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.red}
  }
}

-- Диагностика от LSP сервера
section.right[6] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    separator = " ",
    icon = signs.Error,
    highlight = {colors.red},
  }
}
section.right[7] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = signs.Warning,
    highlight = {colors.yellow},
  }
}
section.right[8] = {
  DiagnosticInfo = {
    provider = "DiagnosticInfo",
    icon = signs.Information,
    highlight = {colors.green},
  }
}
section.right[9] = {
  DiagnosticHint = {
    provider = "DiagnosticHint",
    icon = signs.Hint,
  }
}

-- Замыкает линию номера строки и колонки
section.right[10] = {
  LineInfo = {
    provider = "LineColumn",
  }
}

-- Отступ слева, равный signcolumn
section.short_line_left[1] = {
  FirstElement = {
    provider = function() return '   ' end,
  }
}
-- Тип и (короткое) имя файла
section.short_line_left[2] = {
  SFileIcon = {
    provider = "FileIcon",
    condition = buffer_not_empty
  }
}
section.short_line_left[3] = {
  SFileName = {
    provider = function()
      local fileinfo = require("galaxyline.provider_fileinfo")
      local fname = fileinfo.get_current_file_name()
      for _, v in ipairs(galaxyline.short_line_list) do
        if v == vim.bo.filetype then
          return ""
        end
      end
      return fname
    end,
    condition = buffer_not_empty,
  }
}

-- Типы буфера отличные от файлов
section.short_line_right[1] = {
  BufferIcon = {
    provider = "BufferIcon",
  }
}

