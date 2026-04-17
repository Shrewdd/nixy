{inputs, ...}: {
  imports = [inputs.nixvim.homeModules.nixvim];
  # Keep Nixvim theme config local to this module.
  stylix.targets.nixvim.enable = false;

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    # ── Appearance ─────────────────────────────────────────────────────

    colorschemes.onedark = {
      enable = true;
      settings = {
        style = "dark";
        transparent = false;
      };
    };

    opts = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      wrap = false;
      scrolloff = 8;
      signcolumn = "yes";

      termguicolors = true;
      background = "dark";
      cursorline = true;

      # Split behavior
      splitright = true;
      splitbelow = true;

      # Search
      ignorecase = true;
      smartcase = true;
      hlsearch = false;
      incsearch = true;

      updatetime = 50;
    };

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    # ── Keymaps ────────────────────────────────────────────────────────
    keymaps = [
      # Window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
      }

      # Keep selection after indenting
      {
        mode = "v";
        key = "<";
        action = "<gv";
      }
      {
        mode = "v";
        key = ">";
        action = ">gv";
      }

      # Move selected lines
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
      }

      # Keep cursor centered when jumping
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
      }

      # Save and quit shortcuts
      {
        mode = "n";
        key = "<leader>w";
        action = "<cmd>w<CR>";
        options.desc = "Save";
      }
      {
        mode = "n";
        key = "<leader>q";
        action = "<cmd>q<CR>";
        options.desc = "Quit";
      }

      # Clear search highlight
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
        options.desc = "Open file explorer";
      }
      {
        mode = "n";
        key = "<leader>cc";
        action = "<cmd>CopilotChat<CR>";
        options.desc = "Copilot Chat";
      }
    ];

    # ── Plugins ────────────────────────────────────────────────────────
    plugins = {
      # Syntax parsing and highlighting
      treesitter = {
        enable = true;
        settings = {
          highlight.enable = true;
          indent.enable = true;
          ensure_installed = ["nix" "javascript" "typescript" "tsx" "json" "yaml" "toml" "markdown" "bash"];
        };
      };

      # Status line
      lualine.enable = true;

      # Keybind hint popup
      which-key.enable = true;

      # Auto-close brackets and quotes
      nvim-autopairs.enable = true;

      oil = {
        enable = true;
        settings = {
          default_file_explorer = true;
          view_options.show_hidden = true;
        };
      };

      telescope = {
        enable = true;
        keymaps = {
          "<C-p>" = "find_files";
          "<C-b>" = "buffers";
          "<leader>fr" = "oldfiles";
        };
      };

      copilot-lua = {
        enable = true;
        settings = {
          suggestion = {
            enabled = true;
            auto_trigger = true;
            keymap.accept = "<Tab>";
          };
          panel.enabled = false;
        };
      };

      copilot-chat = {
        enable = true;
        settings = {
          window.layout = "vertical";
        };
      };

      web-devicons.enable = true;

      # Comment toggling (gcc / gc in visual)
      comment.enable = true;

      # Git signs in the gutter
      gitsigns = {
        enable = true;
        settings.signs = {
          add.text = "│";
          change.text = "│";
          delete.text = "_";
        };
      };

      # Discord Rich Presence
      cord = {
        enable = true;
        settings = {
          editor = {
            client = "1484571788494114929";
            icon = "car";
          };
          display = {
            swap_icons = true;
          };
          idle = {
            enabled = true;
            timeout = 900000;
          };
          text = {
            workspace = "working in thigh highs 🧦";
          };
        };
      };
    };
  };
}
