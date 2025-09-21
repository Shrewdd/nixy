{ config, pkgs, ... }:
let
  theme = import ../../shared/theme/everforest.nix;
in
{
  # ===================================
  # GTK GLOBAL CONFIGURATION
  # ===================================
  gtk = {
    enable = true;
    
    
    # Use dark color scheme to match Everforest
    colorScheme = "dark";
    
    # Use Adwaita dark as base theme (closest to Everforest aesthetic)
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    
    # Icon theme that works well with dark themes
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
    
    # Cursor theme
    cursorTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
      size = 24;
    };

    # ===================================
    # GTK 3 SPECIFIC CONFIGURATION
    # ===================================
    gtk3 = {
      enable = true;
      colorScheme = "dark";
      
      # File manager bookmarks
      bookmarks = [
        "file:///home/km/Downloads"
        "file:///home/km/Documents"
        "file:///home/km/Pictures"
        "file:///home/km/nixy"
      ];
      
      # Extra CSS to customize GTK 3 applications with Everforest colors
      extraCss = ''
        /* Everforest GTK 3 Theme Customizations */
        
        /* Window and container backgrounds */
        window,
        .background {
          background-color: #${theme.base};
          color: #${theme.text};
        }
        
        /* Header bars and toolbars */
        headerbar,
        .titlebar,
        toolbar {
          background-color: #${theme.surface2};
          background-image: none;
          border-color: #${theme.overlay0};
          color: #${theme.text};
        }
        
        /* Buttons */
        button {
          background-color: #${theme.surface0};
          background-image: none;
          border-color: #${theme.overlay0};
          color: #${theme.text};
          border-radius: 6px;
        }
        
        button:hover {
          background-color: #${theme.surface1};
          border-color: #${theme.green};
        }
        
        button:active,
        button:checked {
          background-color: #${theme.green};
          color: #${theme.base};
        }
        
        /* Entry fields (text inputs) */
        entry {
          background-color: #${theme.surface0};
          border-color: #${theme.overlay0};
          color: #${theme.text};
          border-radius: 6px;
        }
        
        entry:focus {
          border-color: #${theme.blue};
          box-shadow: 0 0 0 2px alpha(#${theme.blue}, 0.2);
        }
        
        /* Selection colors */
        selection,
        *:selected {
          background-color: #${theme.blue};
          color: #${theme.base};
        }
        
        /* Sidebar styling */
        .sidebar {
          background-color: #${theme.mantle};
          border-color: #${theme.surface1};
        }
        
        /* Scrollbars */
        scrollbar slider {
          background-color: #${theme.overlay0};
          border-radius: 6px;
        }
        
        scrollbar slider:hover {
          background-color: #${theme.overlay1};
        }
        
        /* Menu styling */
        menu,
        .menu {
          background-color: #${theme.surface0};
          border-color: #${theme.surface1};
          color: #${theme.text};
        }
        
        menuitem:hover {
          background-color: #${theme.surface1};
        }
        
        /* Notebook (tab) styling */
        notebook > header {
          background-color: #${theme.surface1};
        }
        
        notebook > header > tabs > tab {
          background-color: #${theme.surface0};
          color: #${theme.subtext1};
          border-color: #${theme.overlay0};
        }
        
        notebook > header > tabs > tab:checked {
          background-color: #${theme.green};
          color: #${theme.base};
        }
        
        /* Progress bars */
        progressbar > trough {
          background-color: #${theme.surface0};
        }
        
        progressbar > trough > progress {
          background-color: #${theme.green};
        }
        
        /* Switch controls */
        switch slider {
          background-color: #${theme.surface2};
        }
        
        switch:checked slider {
          background-color: #${theme.green};
        }
        
        /* Check boxes and radio buttons */
        checkbutton check,
        radiobutton radio {
          background-color: #${theme.surface0};
          border-color: #${theme.overlay0};
        }
        
        checkbutton check:checked,
        radiobutton radio:checked {
          background-color: #${theme.green};
          border-color: #${theme.green};
        }
      '';
      
      # Additional GTK 3 settings
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-button-images = false;
        gtk-menu-images = false;
        gtk-enable-animations = true;
        gtk-primary-button-warps-slider = false;
      };
    };

    # ===================================
    # GTK 4 SPECIFIC CONFIGURATION
    # ===================================
    gtk4 = {
      enable = true;
      colorScheme = "dark";
      
      # Extra CSS for GTK 4 applications
      extraCss = ''
        /* Everforest GTK 4 Theme Customizations */
        
        /* Window backgrounds */
        window {
          background-color: #${theme.base};
          color: #${theme.text};
        }
        
        /* Header bars */
        headerbar {
          background-color: #${theme.surface2};
          color: #${theme.text};
          border-radius: 0;
        }
        
        /* Modern button styling */
        button {
          background: #${theme.surface0};
          border: 1px solid #${theme.overlay0};
          color: #${theme.text};
          border-radius: 8px;
          transition: all 200ms ease;
        }
        
        button:hover {
          background: #${theme.surface1};
          border-color: #${theme.green};
        }
        
        button.suggested-action {
          background: #${theme.green};
          color: #${theme.base};
          border-color: #${theme.green};
        }
        
        button.destructive-action {
          background: #${theme.red};
          color: #${theme.base};
          border-color: #${theme.red};
        }
        
        /* Entry fields */
        entry {
          background: #${theme.surface0};
          border: 1px solid #${theme.overlay0};
          color: #${theme.text};
          border-radius: 8px;
        }
        
        entry:focus-within {
          border-color: #${theme.blue};
          box-shadow: 0 0 0 2px alpha(#${theme.blue}, 0.2);
        }
        
        /* Dropdown menus */
        popover {
          background: #${theme.surface0};
          border: 1px solid #${theme.surface1};
          border-radius: 8px;
        }
        
        /* List items */
        listview > row {
          background: transparent;
          color: #${theme.text};
        }
        
        listview > row:hover {
          background: #${theme.surface1};
        }
        
        listview > row:selected {
          background: #${theme.blue};
          color: #${theme.base};
        }
        
        /* Cards and elevated surfaces */
        .card {
          background: #${theme.surface0};
          border: 1px solid #${theme.surface1};
          border-radius: 12px;
        }
        
        /* Modern switch styling */
        switch {
          background: #${theme.surface1};
          border-radius: 16px;
        }
        
        switch:checked {
          background: #${theme.green};
        }
        
        switch slider {
          background: #${theme.text};
          border-radius: 50%;
          transition: all 200ms ease;
        }
      '';
      
      # Additional GTK 4 settings
      extraConfig = {
        gtk-application-prefer-dark-theme = true;
        gtk-hint-font-metrics = true;
      };
    };

    # ===================================
    # GTK 2 CONFIGURATION (Legacy)
    # ===================================
    gtk2 = {
      enable = true;
      
      # Basic GTK 2 theme
      theme = {
        name = "Adwaita-dark";
        package = pkgs.gnome-themes-extra;
      };
      
      # Extra GTK 2 configuration
      extraConfig = ''
        gtk-theme-name="Adwaita-dark"
        gtk-icon-theme-name="Adwaita"
        gtk-cursor-theme-name="Adwaita"
        gtk-cursor-theme-size=24
        gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
        gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
        gtk-button-images=0
        gtk-menu-images=0
        gtk-enable-event-sounds=0
        gtk-enable-input-feedback-sounds=0
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
    };
  };
}