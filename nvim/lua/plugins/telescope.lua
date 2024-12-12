local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")

-- Don't preview binary files
local previewers = require("telescope.previewers")
local Job = require("plenary.job")
local new_maker = function(filepath, bufnr, opts)
  filepath = vim.fn.expand(filepath)
  Job:new({
    command = "file",
    args = { "--mime-type", "-b", filepath },
    on_exit = function(j)
      local mime_type = vim.split(j:result()[1], "/")[1]
      local mime_subtype = vim.split(j:result()[1], "/")[2]
      if
        mime_type == "text"
        or (
          mime_type == "application"
            and ("json|toml|xml|x-latex|x-troff|x-sh|x-csh|x-zsh|x-tex|x-texinfo"):find(mime_subtype)
          or (mime_type == "inode" and ("x-empty|"):find(mime_subtype))
        )
      then
        previewers.buffer_previewer_maker(filepath, bufnr, opts)
      else
        -- maybe we want to write something to the buffer here
        vim.schedule(function()
          vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { "BINARY" })
        end)
      end
    end,
  }):sync()
end

-- Additional Telescope customization
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "polirritmico/telescope-lazy-plugins.nvim",
      "nvim-telescope/telescope-frecency.nvim",
      "benfowler/telescope-luasnip.nvim",
      "ghassan0/telescope-glyph.nvim",
      "xiyaowong/telescope-emoji.nvim",
      "nvim-telescope/telescope-symbols.nvim",
      "tsakirist/telescope-lazy.nvim",
      "nvim-telescope/telescope-file-browser.nvim",
      "nvim-telescope/telescope-project.nvim",
      "nvim-telescope/telescope-bibtex.nvim",
      "jvgrootveld/telescope-zoxide",
      "fdschmidt93/telescope-egrepify.nvim",
    },
    config = function()
      require("telescope").load_extension("lazy_plugins")
      require("telescope").load_extension("frecency")
      require("telescope").load_extension("luasnip")
      require("telescope").load_extension("glyph")
      require("telescope").load_extension("emoji")
      require("telescope").load_extension("lazy")
      require("telescope").load_extension("file_browser")
      require("telescope").load_extension("project")
      require("telescope").load_extension("projects") -- this is for project.nvim
      require("telescope").load_extension("bibtex")
      require("telescope").load_extension("zoxide")
      require("telescope").load_extension("egrepify")
    end,
    init = function()
      require("telescope").setup({
        defaults = {
          buffer_previewer_maker = new_maker, -- don't preview binary files
          mappings = {
            i = {
              ["<esc>"] = actions.close, -- close with Esc in insert mode
              ["<C-u>"] = false, -- clear prompt
              ["<C-d>"] = actions.delete_buffer + actions.move_to_top, -- delete a buffer from the picker
              ["<M-p>"] = action_layout.toggle_preview, -- toggle preview
              ["<C-h>"] = actions.which_key, -- show the mappings for the picker
            },
            n = {
              ["<M-p>"] = action_layout.toggle_preview, -- toggle preview
            },
          },
          preview = {
            -- preview images with catimg
            mime_hook = function(filepath, bufnr, opts)
              local is_image = function(filepath)
                local image_extensions = { "png", "jpg" } -- Supported image formats
                local split_path = vim.split(filepath:lower(), ".", { plain = true })
                local extension = split_path[#split_path]
                return vim.tbl_contains(image_extensions, extension)
              end
              if is_image(filepath) then
                local term = vim.api.nvim_open_term(bufnr, {})
                local function send_output(_, data, _)
                  for _, d in ipairs(data) do
                    vim.api.nvim_chan_send(term, d .. "\r\n")
                  end
                end
                vim.fn.jobstart({
                  "catimg",
                  filepath, -- Terminal image viewer command
                }, { on_stdout = send_output, stdout_buffered = true, pty = true })
              else
                require("telescope.previewers.utils").set_preview_message(
                  bufnr,
                  opts.winid,
                  "Binary cannot be previewed"
                )
              end
            end,
          },
        },
      })
    end,
  },
}
