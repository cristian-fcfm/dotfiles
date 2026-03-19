# Kitty Modular Config with Platform-Specific Support

## Problem

The kitty configuration lives in a single 332-line `kitty.conf` that mixes shared settings with platform-specific options (macOS vs Linux). This makes it hard to navigate, and changing machines requires manual edits to font size and emoji fonts.

## Goals

1. **Modularize** `kitty.conf` into thematic files for easier navigation and maintenance
2. **Platform-aware configs** that work on both Linux and macOS without manual edits
3. **Use GNU Stow** for deployment with a global ignore pattern to filter platform files

## Design

### File Structure

```
dotfiles/
├── stow-config/
│   └── .stow-global-ignore              # Filters platform files per OS
├── kitty/
│   └── .config/kitty/
│       ├── kitty.conf                    # Orchestrator — only includes
│       ├── core.conf                     # Cursor, scrollback, mouse, performance, transparency, audio, advanced, vim-slime
│       ├── theme.conf                    # Kanagawa Dragon color scheme (renamed from Kanagawa_dragon.conf)
│       ├── fonts.conf                    # Font family, ligatures, font_features (no font_size, no emoji symbol_map)
│       ├── tabs.conf                     # Tab bar: edge, style, templates, background
│       ├── layouts.conf                  # Enabled layouts, window sizing, borders, padding, decorations
│       ├── keybindings.conf              # All shortcuts: clipboard, scroll, tabs, splits, resize, font size, utilities, opacity
│       ├── platform/
│       │   ├── linux.conf                # font_size 12.0, Noto Color Emoji, linux_display_server
│       │   └── macos.conf                # font_size 14.0, Apple Color Emoji, macos_* options
│       └── tab_bar.py                    # Custom tab bar (unchanged)
```

### kitty.conf (Orchestrator)

```conf
# vim:fileencoding=utf-8:foldmethod=marker
# Kitty configuration - modular includes
include theme.conf
include fonts.conf
include core.conf
include tabs.conf
include layouts.conf
include keybindings.conf

# Platform-specific (only the existing file loads, the other is silently ignored)
include platform/linux.conf
include platform/macos.conf
```

### Module Breakdown

#### core.conf
- Cursor: shape, thickness, blink
- Scrollback: lines, pager, history size, wheel scroll
- Mouse: hide, URL detection, copy_on_select, paste actions, word characters, pointer shapes
- Performance: input_delay, repaint_delay, sync_to_monitor
- Transparency: background_opacity, dynamic
- Audio: bell disabled, visual bell, alert on bell
- Advanced: shell, editor, clipboard, hyperlinks, shell_integration
- Vim-slime: remote control, listen_on

#### theme.conf
- Renamed from `Kanagawa_dragon.conf`
- All color definitions (foreground, background, 16 colors, selection, cursor, URL, tab bar)

#### fonts.conf
- font_family: FiraCode Nerd Font
- bold/italic/bold_italic: auto
- enable_ligatures: yes
- font_features: +zero +calt +ss01 +ss02 +cv01-cv06 +frac +subs +sups +sinf
- Note: `font_size` and emoji `symbol_map` live in platform files

#### tabs.conf
- tab_bar_edge, tab_bar_min_tabs, tab_bar_margin_height/width
- tab_bar_background, tab_bar_style, tab_separator
- tab_title_template, active_tab_title_template

#### layouts.conf
- enabled_layouts: splits, stack, tall, *
- remember_window_size, initial_window_width/height
- window_resize_step_cells/lines, window_border_width, draw_minimal_borders
- window_margin_width, single_window_margin_width, window_padding_width
- placement_strategy, inactive_text_alpha, hide_window_decorations
- resize_debounce_time, resize_in_steps, visual_window_select_characters
- confirm_os_window_close

#### keybindings.conf
- clear_all_shortcuts yes
- Clipboard: copy/paste
- Scrollback & search: scroll, show_scrollback, fzf search
- Tabs: new, close, navigate, reorder, goto by number, rename
- Layouts: zoom toggle, goto splits, cycle
- Splits/windows: create vsplit/hsplit, close, navigate (ctrl+hjkl with Neovim passthrough), visual select, cycle, move, resize
- Font size: increase, decrease, reset
- Utilities: fullscreen, maximize, unicode input, edit config, kitty shell, clear terminal, load config, debug config
- Background opacity: adjust, reset

#### platform/linux.conf
```conf
# Linux-specific (Arch - Wayland/X11)
font_size 12.0
symbol_map U+1F300-U+1F6FF Noto Color Emoji
linux_display_server auto
```

#### platform/macos.conf
```conf
# macOS-specific
font_size 14.0
symbol_map U+1F300-U+1F6FF Apple Color Emoji
macos_option_as_alt left
macos_quit_when_last_window_closed yes
macos_thicken_font 0.15
macos_traditional_fullscreen no
macos_show_window_title_in none
```

### Stow Strategy

A `stow-config` package manages `~/.stow-global-ignore`, which filters platform files globally across all packages.

**`stow-config/.stow-global-ignore` on Linux:**
```
platform/macos\.conf
```

**`stow-config/.stow-global-ignore` on macOS:**
```
platform/linux\.conf
```

**Installation (same command on both OS):**
```bash
cd ~/dotfiles
stow stow-config    # Deploys ~/.stow-global-ignore
stow kitty          # Deploys kitty config, platform file filtered by global ignore
```

This pattern scales to any future package that needs platform-specific files — just add `platform/linux.conf` and `platform/macos.conf` inside the package.

### Scalability

Other packages can adopt the same pattern:
```
zsh/
└── .config/zsh/
    └── platform/
        ├── linux.conf
        └── macos.conf
```

The global ignore handles filtering automatically.

## Migration

1. Create the `stow-config` package with `.stow-global-ignore`
2. Split `kitty.conf` into module files
3. Rename `Kanagawa_dragon.conf` to `theme.conf` and update the include
4. Create `platform/linux.conf` and `platform/macos.conf`
5. Reduce `kitty.conf` to only includes
6. Test with `stow --simulate kitty` to verify symlinks
7. Deploy with `stow kitty`
