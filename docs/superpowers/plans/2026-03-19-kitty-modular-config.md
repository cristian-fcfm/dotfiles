# Kitty Modular Config Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Split `kitty.conf` into thematic modules and add platform-specific configs (Linux/macOS) managed via GNU Stow global ignore.

**Architecture:** The monolithic `kitty.conf` is split into 6 thematic includes (theme, fonts, core, tabs, layouts, keybindings) plus a `platform/` directory with Linux- and macOS-specific overrides. GNU Stow deploys only the correct platform file by filtering via `~/.stow-global-ignore`, which is itself managed as a `stow-config` package.

**Tech Stack:** kitty terminal config (`.conf`), GNU Stow, bash (`uname -s`)

---

## File Map

| Action | Path | Responsibility |
|--------|------|----------------|
| Create | `stow-config/.stow-global-ignore` | Stow global ignore — built-in defaults + Linux platform filter |
| Modify | `kitty/.config/kitty/kitty.conf` | Reduce to only `include` directives |
| Create | `kitty/.config/kitty/theme.conf` | Kanagawa Dragon colors (moved from Kanagawa_dragon.conf) |
| Create | `kitty/.config/kitty/fonts.conf` | Font family, ligatures, font_features (no font_size, no emoji) |
| Create | `kitty/.config/kitty/core.conf` | Cursor, scrollback, mouse, performance, transparency, audio, advanced, vim-slime |
| Create | `kitty/.config/kitty/tabs.conf` | Tab bar settings |
| Create | `kitty/.config/kitty/layouts.conf` | Layouts, window sizing, borders, padding |
| Create | `kitty/.config/kitty/keybindings.conf` | All shortcuts |
| Create | `kitty/.config/kitty/platform/linux.conf` | font_size 12.0, Noto emoji, linux_display_server |
| Create | `kitty/.config/kitty/platform/macos.conf` | font_size 14.0, Apple emoji, macos_* options |
| Delete | `kitty/.config/kitty/Kanagawa_dragon.conf` | Replaced by theme.conf |

---

## Task 1: Create stow-config package

**Files:**
- Create: `stow-config/.stow-global-ignore`

This is the Linux version (the machine where these dotfiles live). macOS machines will need to swap `platform/macos\.conf` for `platform/linux\.conf`.

- [ ] **Step 1: Create the directory**

```bash
mkdir -p ~/Documents/development/personal/dotfiles/stow-config
```

- [ ] **Step 2: Create `.stow-global-ignore`**

Create `stow-config/.stow-global-ignore` with this content:

```
# Stow built-in defaults (required — global ignore replaces them entirely)
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

# Platform filter (Linux machine: ignore macOS platform files)
platform/macos\.conf
```

- [ ] **Step 3: Verify stow-config deploys correctly (dry run)**

```bash
cd ~/Documents/development/personal/dotfiles
stow --simulate stow-config
```

Expected output: something like `LINK: .stow-global-ignore => ...` with no errors.

- [ ] **Step 4: Deploy stow-config**

```bash
stow stow-config
```

- [ ] **Step 5: Confirm file landed in home**

```bash
ls -la ~/.stow-global-ignore
cat ~/.stow-global-ignore
```

Expected: symlink pointing to `dotfiles/stow-config/.stow-global-ignore`.

- [ ] **Step 6: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add stow-config/.stow-global-ignore
git commit -m "feat(stow): add stow-config package with global ignore for platform files"
```

---

## Task 2: Create theme.conf

**Files:**
- Create: `kitty/.config/kitty/theme.conf`
- The original `Kanagawa_dragon.conf` will be deleted in Task 8.

- [ ] **Step 1: Create `theme.conf` by copying Kanagawa_dragon.conf**

```bash
cp ~/Documents/development/personal/dotfiles/kitty/.config/kitty/Kanagawa_dragon.conf \
   ~/Documents/development/personal/dotfiles/kitty/.config/kitty/theme.conf
```

- [ ] **Step 2: Verify content**

```bash
head -5 ~/Documents/development/personal/dotfiles/kitty/.config/kitty/theme.conf
```

Expected: starts with color definitions (foreground, background, etc.).

- [ ] **Step 3: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/theme.conf
git commit -m "feat(kitty): extract theme.conf from Kanagawa_dragon.conf"
```

---

## Task 3: Create fonts.conf

**Files:**
- Create: `kitty/.config/kitty/fonts.conf`

Note: `font_size` and `symbol_map` (emoji) are intentionally excluded — they live in `platform/*.conf`.

- [ ] **Step 1: Create `fonts.conf`**

Create `kitty/.config/kitty/fonts.conf` with this content:

```conf
# vim:fileencoding=utf-8:foldmethod=marker

# ========================================
# FONTS
# ========================================
font_family        FiraCode Nerd Font
bold_font          auto
italic_font        auto
bold_italic_font   auto

# Programming ligatures
enable_ligatures   yes

# Advanced typographic features
font_features      FiraCode Nerd Font +zero +calt +ss01 +ss02 +cv01 +cv02 +cv03 +cv04 +cv05 +cv06 +frac +subs +sups +sinf

# Note: font_size and symbol_map (emoji) are in platform/linux.conf or platform/macos.conf
```

- [ ] **Step 2: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/fonts.conf
git commit -m "feat(kitty): extract fonts.conf module"
```

---

## Task 4: Create core.conf

**Files:**
- Create: `kitty/.config/kitty/core.conf`

This file holds everything that doesn't belong in a specialized module: cursor, scrollback, mouse, performance, transparency, audio, advanced settings, and vim-slime remote control.

- [ ] **Step 1: Create `core.conf`**

Create `kitty/.config/kitty/core.conf` with this content (extracted verbatim from the original `kitty.conf`):

```conf
# vim:fileencoding=utf-8:foldmethod=marker

# ========================================
# CURSOR
# ========================================
cursor_shape beam
cursor_shape_unfocused hollow
cursor_beam_thickness 1.5
cursor_blink_interval 0
cursor_stop_blinking_after 0
cursor_trail 0

# ========================================
# SCROLLBACK
# ========================================
# 50k lines for data science (large DataFrame prints, logs)
scrollback_lines 50000
scrollback_indicator_opacity 0.7
scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER
# 100MB pager history — enough for large training logs and pandas output
scrollback_pager_history_size 100
scrollback_fill_enlarged_window no
wheel_scroll_multiplier 3.0
wheel_scroll_min_lines 1
touch_scroll_multiplier 1.0

# ========================================
# MOUSE
# ========================================
mouse_hide_wait -1.0
url_style curly
open_url_with default
url_prefixes file ftp ftps gemini git gopher http https irc ircs kitty mailto news sftp ssh
detect_urls yes
show_hyperlink_targets yes
underline_hyperlinks hover

# copy_on_select is useful for grabbing data science output quickly
copy_on_select yes
clear_selection_on_clipboard_loss no
paste_actions quote-urls-at-prompt,confirm
strip_trailing_spaces smart

select_by_word_characters @-./_~?&=%+#
select_by_word_characters_forward
click_interval -1.0
focus_follows_mouse no
pointer_shape_when_grabbed arrow
default_pointer_shape beam
pointer_shape_when_dragging beam

# ========================================
# PERFORMANCE & RENDERING
# ========================================
input_delay 3
repaint_delay 10
sync_to_monitor yes

# ========================================
# TRANSPARENCY
# ========================================
background_opacity 1.0
dynamic_background_opacity yes

# ========================================
# AUDIO & NOTIFICATIONS
# ========================================
enable_audio_bell no
visual_bell_duration 0.0
window_alert_on_bell yes
bell_on_tab " "

# ========================================
# ADVANCED
# ========================================
shell zsh
editor nvim
close_on_child_death no
update_check_interval 24
clipboard_max_size 512
allow_hyperlinks yes
shell_integration enabled
notify_on_cmd_finish never
forward_stdio no

# ========================================
# VIM-SLIME INTEGRATION
# ========================================
# Remote control required for vim-slime and kw()/kdev() shell functions
allow_remote_control yes
listen_on unix:/tmp/mykitty
```

- [ ] **Step 2: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/core.conf
git commit -m "feat(kitty): extract core.conf module"
```

---

## Task 5: Create tabs.conf

**Files:**
- Create: `kitty/.config/kitty/tabs.conf`

- [ ] **Step 1: Create `tabs.conf`**

Create `kitty/.config/kitty/tabs.conf` with this content:

```conf
# vim:fileencoding=utf-8:foldmethod=marker

# ========================================
# TABS
# ========================================
tab_bar_edge            top
tab_bar_min_tabs        2
tab_bar_margin_height   0 0
tab_bar_margin_width    10
# Use background from Kanagawa Dragon (dark variant)
tab_bar_background      #0d0c0c
# Show user-set title if available, fall back to running command
tab_title_template      "{fmt.noitalic}{fmt.fg.tab}{index} 󱥸 {tab.active_oldest_exe}{activity_symbol}{fmt.fg.red}{bell_symbol}"
active_tab_title_template "{fmt.noitalic}{fmt.fg.tab}{index}  {tab.active_oldest_exe}{activity_symbol}{fmt.fg.red}{bell_symbol}"
tab_bar_style custom
tab_separator ""
```

- [ ] **Step 2: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/tabs.conf
git commit -m "feat(kitty): extract tabs.conf module"
```

---

## Task 6: Create layouts.conf

**Files:**
- Create: `kitty/.config/kitty/layouts.conf`

- [ ] **Step 1: Create `layouts.conf`**

Create `kitty/.config/kitty/layouts.conf` with this content:

```conf
# vim:fileencoding=utf-8:foldmethod=marker

# ========================================
# LAYOUTS - Kitty as primary multiplexer
# ========================================
# splits  = primary layout for development (vsplit/hsplit panes)
# stack   = focus mode: zoom a single pane full-screen (Ctrl+Shift+Z)
# tall    = one main pane + stacked secondaries
enabled_layouts splits, stack, tall, *
remember_window_size  yes
initial_window_width  1200
initial_window_height 800

window_resize_step_cells 2
window_resize_step_lines 2
window_border_width 1pt
draw_minimal_borders yes
window_margin_width 0
single_window_margin_width -1
window_padding_width 5
placement_strategy center

inactive_text_alpha 0.7
hide_window_decorations no
resize_debounce_time 0.1 0.5
resize_in_steps no
visual_window_select_characters 1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZ
confirm_os_window_close 0
```

- [ ] **Step 2: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/layouts.conf
git commit -m "feat(kitty): extract layouts.conf module"
```

---

## Task 7: Create keybindings.conf

**Files:**
- Create: `kitty/.config/kitty/keybindings.conf`

- [ ] **Step 1: Create `keybindings.conf`**

Create `kitty/.config/kitty/keybindings.conf` with this content:

```conf
# vim:fileencoding=utf-8:foldmethod=marker

# ========================================
# SHORTCUTS - Kitty as primary multiplexer
# ========================================
# Philosophy: Kitty replaces tmux for local work.
#   Tabs    = tmux sessions/windows (named project workspaces)
#   Splits  = tmux panes (editor + REPL, logs, etc.)
#   Stack   = tmux zoom (Ctrl+Shift+Z to focus one pane)
#
# Modifier scheme:
#   Ctrl+HJKL        = split navigation (seamless with Neovim via smart-splits.nvim)
#   Ctrl+Shift       = primary actions (tabs, create/close, layouts, utilities)
#   Ctrl+Shift+HJKL  = passed to Neovim when focused (mini.move: line/block movement)
#   Ctrl+Alt         = resize & secondary actions
#   Ctrl+Shift+Alt   = move/reorder windows

clear_all_shortcuts yes

# ========================================
# CLIPBOARD
# ========================================
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard

# ========================================
# SCROLLBACK & SEARCH
# ========================================
map ctrl+shift+up        scroll_line_up
map ctrl+shift+down      scroll_line_down
map ctrl+shift+page_up   scroll_page_up
map ctrl+shift+page_down scroll_page_down
map ctrl+shift+home      scroll_home
map ctrl+shift+end       scroll_end
map ctrl+shift+g         show_last_command_output

# Browse scrollback in pager (less)
map ctrl+shift+b         show_scrollback

# Fuzzy search scrollback with fzf
map ctrl+shift+f launch --type=overlay --stdin-source=@screen_scrollback fzf --no-sort --no-mouse --exact -i

# ========================================
# TABS (= tmux sessions/windows)
# ========================================
# Create / close
map ctrl+shift+t new_tab_with_cwd
map ctrl+shift+q close_tab

# Navigate
map ctrl+shift+right next_tab
map ctrl+shift+left  previous_tab

# Reorder
map ctrl+alt+right move_tab_forward
map ctrl+alt+left  move_tab_backward

# Jump to tab by number
map ctrl+shift+1 goto_tab 1
map ctrl+shift+2 goto_tab 2
map ctrl+shift+3 goto_tab 3
map ctrl+shift+4 goto_tab 4
map ctrl+shift+5 goto_tab 5
map ctrl+shift+6 goto_tab 6
map ctrl+shift+7 goto_tab 7
map ctrl+shift+8 goto_tab 8
map ctrl+shift+9 goto_tab 9

# Rename tab (like tmux rename-window)
map ctrl+shift+r set_tab_title

# ========================================
# LAYOUTS
# ========================================
# Zoom toggle: switch between splits and stack (like tmux prefix+z)
map ctrl+shift+z     toggle_layout stack
# Return to splits layout
map ctrl+shift+s     goto_layout splits
# Cycle through all layouts
map ctrl+shift+space next_layout

# ========================================
# SPLITS/WINDOWS (= tmux panes)
# ========================================
# Create splits
map ctrl+shift+\     launch --location=vsplit --cwd=current
map ctrl+shift+-     launch --location=hsplit --cwd=current
map ctrl+shift+enter new_window_with_cwd
map ctrl+alt+n       new_os_window

# Close
map ctrl+shift+w close_window

# Navigate with Ctrl+HJKL — seamless Neovim <-> Kitty via smart-splits.nvim
# When NOT in Neovim: Kitty handles the navigation
map ctrl+h neighboring_window left
map ctrl+l neighboring_window right
map ctrl+k neighboring_window up
map ctrl+j neighboring_window down
# When in Neovim: unmap so keys pass through (smart-splits handles boundary detection)
map --when-focus-on var:IS_NVIM ctrl+h
map --when-focus-on var:IS_NVIM ctrl+l
map --when-focus-on var:IS_NVIM ctrl+k
map --when-focus-on var:IS_NVIM ctrl+j

# Ctrl+Shift+HJKL: pass through to Neovim for mini.move (line/block movement)
# When NOT in Neovim: no action (Kitty splits use Ctrl+HJKL above)
map --when-focus-on var:IS_NVIM ctrl+shift+h
map --when-focus-on var:IS_NVIM ctrl+shift+l
map --when-focus-on var:IS_NVIM ctrl+shift+k
map --when-focus-on var:IS_NVIM ctrl+shift+j

# Visual select: pick a window by number overlay (useful with 3+ splits)
map ctrl+shift+o focus_visible_window

# Cycle windows
map ctrl+shift+n next_window
map ctrl+shift+p previous_window

# Move windows
map ctrl+shift+alt+h move_window left
map ctrl+shift+alt+l move_window right
map ctrl+shift+alt+k move_window up
map ctrl+shift+alt+j move_window down
map ctrl+shift+.     move_window_forward
map ctrl+shift+,     move_window_backward

# Resize windows
map ctrl+alt+h resize_window narrower 2
map ctrl+alt+l resize_window wider 2
map ctrl+alt+k resize_window taller 2
map ctrl+alt+j resize_window shorter 2
map ctrl+shift+= resize_window reset

# ========================================
# FONT SIZE
# ========================================
map ctrl+shift+equal       change_font_size all +1.0
map ctrl+shift+plus        change_font_size all +1.0
map ctrl+shift+kp_add      change_font_size all +1.0
map ctrl+shift+minus       change_font_size all -1.0
map ctrl+shift+kp_subtract change_font_size all -1.0
map ctrl+shift+backspace   change_font_size all 0

# ========================================
# UTILITIES
# ========================================
map ctrl+shift+f11    toggle_fullscreen
map ctrl+shift+f10    toggle_maximized
map ctrl+shift+u      kitten unicode_input
map ctrl+shift+f2     edit_config_file
map ctrl+shift+escape kitty_shell window
map ctrl+shift+delete clear_terminal reset active
map ctrl+shift+f5     load_config_file
map ctrl+shift+f6     debug_config

# ========================================
# BACKGROUND OPACITY
# ========================================
map ctrl+shift+a>m set_background_opacity +0.1
map ctrl+shift+a>l set_background_opacity -0.1
map ctrl+shift+a>1 set_background_opacity 1
map ctrl+shift+a>d set_background_opacity default
```

- [ ] **Step 2: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/keybindings.conf
git commit -m "feat(kitty): extract keybindings.conf module"
```

---

## Task 8: Create platform files

**Files:**
- Create: `kitty/.config/kitty/platform/linux.conf`
- Create: `kitty/.config/kitty/platform/macos.conf`

- [ ] **Step 1: Create the platform directory**

```bash
mkdir -p ~/Documents/development/personal/dotfiles/kitty/.config/kitty/platform
```

- [ ] **Step 2: Create `platform/linux.conf`**

Create `kitty/.config/kitty/platform/linux.conf` with this content:

```conf
# Linux-specific (Arch - Wayland/X11)
font_size 12.0
symbol_map U+1F300-U+1F6FF Noto Color Emoji
linux_display_server auto
```

- [ ] **Step 3: Create `platform/macos.conf`**

Create `kitty/.config/kitty/platform/macos.conf` with this content:

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

- [ ] **Step 4: Commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/platform/
git commit -m "feat(kitty): add platform-specific configs (linux and macos)"
```

---

## Task 9: Rewrite kitty.conf as orchestrator and remove Kanagawa_dragon.conf

**Files:**
- Modify: `kitty/.config/kitty/kitty.conf`
- Delete: `kitty/.config/kitty/Kanagawa_dragon.conf`

- [ ] **Step 1: Replace kitty.conf with orchestrator-only content**

Overwrite `kitty/.config/kitty/kitty.conf` with:

```conf
# vim:fileencoding=utf-8:foldmethod=marker
# Kitty configuration — modular includes
# Edit the individual module files, not this one.

include theme.conf
include fonts.conf
include core.conf
include tabs.conf
include layouts.conf
include keybindings.conf

# Platform-specific overrides (font_size, emoji font, OS options)
# Only the file that exists on disk is loaded; the other is silently ignored by kitty.
# Stow filters the wrong platform file via ~/.stow-global-ignore at deploy time.
include platform/linux.conf
include platform/macos.conf
```

- [ ] **Step 2: Delete Kanagawa_dragon.conf**

```bash
git rm ~/Documents/development/personal/dotfiles/kitty/.config/kitty/Kanagawa_dragon.conf
```

- [ ] **Step 3: Stage and commit**

```bash
cd ~/Documents/development/personal/dotfiles
git add kitty/.config/kitty/kitty.conf
git commit -m "refactor(kitty): reduce kitty.conf to include orchestrator, remove Kanagawa_dragon.conf"
```

---

## Task 10: Deploy with stow and verify kitty loads correctly

- [ ] **Step 1: Check if kitty config is currently stowed (has symlinks)**

```bash
ls -la ~/.config/kitty/kitty.conf
```

If it's a symlink into the dotfiles repo, unstow first:

```bash
cd ~/Documents/development/personal/dotfiles
stow -D kitty
```

If it's a regular file (not stowed), skip the unstow step.

- [ ] **Step 2: Dry-run stow to verify symlinks**

```bash
cd ~/Documents/development/personal/dotfiles
stow --simulate kitty
```

Expected: list of LINK entries for `kitty.conf`, `theme.conf`, `fonts.conf`, `core.conf`, `tabs.conf`, `layouts.conf`, `keybindings.conf`, `platform/linux.conf`, `tab_bar.py`. No `platform/macos.conf` (filtered by global ignore). No errors.

- [ ] **Step 3: Deploy**

```bash
stow kitty
```

- [ ] **Step 4: Verify platform/macos.conf was NOT deployed**

```bash
ls ~/.config/kitty/platform/
```

Expected: only `linux.conf` present. `macos.conf` absent.

- [ ] **Step 5: Reload kitty config and verify no errors**

Inside a running kitty window:

Press `Ctrl+Shift+F5` (load_config_file keybinding) or restart kitty.

Then press `Ctrl+Shift+F6` (debug_config) and check the output for any errors or warnings.

- [ ] **Step 6: Verify font size is 12.0 on Linux**

In kitty debug output, confirm `font_size` is `12.0`.

- [ ] **Step 7: Final commit (update plan status note)**

```bash
cd ~/Documents/development/personal/dotfiles
git add -A
git commit -m "chore(kitty): deploy modular config via stow"
```

---

## Verification Checklist

After all tasks complete, confirm:

- [ ] `~/.config/kitty/kitty.conf` is a symlink pointing into dotfiles
- [ ] `~/.config/kitty/platform/linux.conf` exists and is a symlink
- [ ] `~/.config/kitty/platform/macos.conf` does NOT exist
- [ ] `~/.config/kitty/Kanagawa_dragon.conf` does NOT exist
- [ ] `~/.stow-global-ignore` is a symlink pointing into `stow-config/`
- [ ] Kitty loads with no errors (`Ctrl+Shift+F6`)
- [ ] Font renders at size 12.0
- [ ] Tab bar renders correctly (custom `tab_bar.py` still active)
- [ ] Neovim split navigation (Ctrl+HJKL) still works
