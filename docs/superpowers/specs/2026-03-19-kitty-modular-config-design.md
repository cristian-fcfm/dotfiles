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

All settings from the original kitty.conf that don't belong in a specialized module. Specifically:

- Cursor: cursor_shape, cursor_shape_unfocused, cursor_beam_thickness, cursor_blink_interval, cursor_stop_blinking_after, cursor_trail
- Scrollback: scrollback_lines, scrollback_indicator_opacity, scrollback_pager, scrollback_pager_history_size, scrollback_fill_enlarged_window, wheel_scroll_multiplier, wheel_scroll_min_lines, touch_scroll_multiplier
- Mouse: mouse_hide_wait, url_style, open_url_with, url_prefixes, detect_urls, show_hyperlink_targets, underline_hyperlinks, copy_on_select, clear_selection_on_clipboard_loss, paste_actions, strip_trailing_spaces, select_by_word_characters, select_by_word_characters_forward, click_interval, focus_follows_mouse, pointer_shape_when_grabbed, default_pointer_shape, pointer_shape_when_dragging
- Performance: input_delay, repaint_delay, sync_to_monitor
- Transparency: background_opacity, dynamic_background_opacity
- Audio: enable_audio_bell, visual_bell_duration, window_alert_on_bell, bell_on_tab
- Advanced: shell, editor, close_on_child_death, update_check_interval, clipboard_max_size, allow_hyperlinks, shell_integration, notify_on_cmd_finish, forward_stdio
- Vim-slime: allow_remote_control, listen_on

#### theme.conf
- Renamed from `Kanagawa_dragon.conf`
- All color definitions (foreground, background, 16 colors, selection, cursor, URL, tab bar)

#### fonts.conf
- font_family: FiraCode Nerd Font
- bold/italic/bold_italic: auto
- enable_ligatures: yes
- font_features: `FiraCode Nerd Font +zero +calt +ss01 +ss02 +cv01 +cv02 +cv03 +cv04 +cv05 +cv06 +frac +subs +sups +sinf`
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

#### tab_bar.py
- Custom Python tab bar implementation (carried over as-is, no changes)

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

**Important**: When `~/.stow-global-ignore` exists, stow stops using its built-in default ignore list. The file must include stow's defaults (`.git`, `README.*`, etc.) plus our platform filter. Stow filters out the wrong platform file at deployment time so it never appears in `~/.config/kitty/platform/`, and kitty's `include` silently ignores the missing file.

**`stow-config/.stow-global-ignore` on Linux:**
```
# Stow built-in defaults (required — global ignore replaces them)
\.git
\.gitignore
\.gitmodules
README.*
LICENSE.*
COPYING
INSTALL
\.cvsignore
\.#.*
CVS
RCS
SCCS
_darcs
\.hg
\.svn
\.osc

# Platform filter
platform/macos\.conf
```

**`stow-config/.stow-global-ignore` on macOS:**
```
# Stow built-in defaults (required — global ignore replaces them)
\.git
\.gitignore
\.gitmodules
README.*
LICENSE.*
COPYING
INSTALL
\.cvsignore
\.#.*
CVS
RCS
SCCS
_darcs
\.hg
\.svn
\.osc

# Platform filter
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

1. Unstow current kitty config if already stowed: `stow -D kitty`
2. Create the `stow-config` package with `.stow-global-ignore` (including stow built-in defaults)
3. Split `kitty.conf` into module files
4. Rename `Kanagawa_dragon.conf` to `theme.conf` and update the include
5. Create `platform/linux.conf` and `platform/macos.conf`
6. Reduce `kitty.conf` to only includes
7. Deploy stow-config: `stow stow-config`
8. Test with `stow --simulate kitty` to verify symlinks
9. Deploy with `stow kitty`
