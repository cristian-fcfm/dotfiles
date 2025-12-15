import os
from datetime import datetime

from kitty.fast_data_types import Screen, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)
from kitty.utils import color_as_int

###########################################################
####################### PARAMETROS ########################
###########################################################

opts = get_options()

colors = {
    "fg": as_rgb(color_as_int(opts.inactive_tab_foreground)),
    "bg": as_rgb(color_as_int(opts.inactive_tab_background)),
    "active_fg": as_rgb(color_as_int(opts.active_tab_foreground)),
    "active_bg": as_rgb(color_as_int(opts.active_tab_background)),
    "bar_bg": as_rgb(color_as_int(opts.tab_bar_background)),
    "accent": as_rgb(color_as_int(opts.selection_background)),
    "background": as_rgb(color_as_int(opts.background)),
}

symbols = {
    "separator_right": "",
    "separator_left": "",
    "window": " 󰬸 ",
    "clock": "󱛡 ",
    "host": "󰒋 ",
}

###########################################################
################## FUNCIONES AUXILIARES ###################
###########################################################


def _calculate_right_width(cells) -> int:
    width = 0
    for fg, bg, content in cells:
        width += len(content)

    return width


##########################################################
######################## LEFT TAB #########################
###########################################################


def _draw_left(screen: Screen) -> int:
    user = os.environ.get("USER") or os.environ.get("USERNAME") or "?"
    screen.cursor.bg = colors["bg"]
    screen.cursor.fg = colors["active_fg"]
    screen.draw(f"󰣇 {user}")
    screen.cursor.x = len(f"󰣇 {user}")

    screen.cursor.fg = colors["bg"]
    screen.cursor.bg = colors["bar_bg"]
    screen.draw(symbols["separator_right"] + " ")

    return screen.cursor.x


###########################################################
######################### TAB BAR #########################
###########################################################


def _draw_window_count(screen: Screen, num_window_groups: int) -> bool:
    if num_window_groups > 1:
        screen.draw(symbols["window"] + str(num_window_groups))
    return True


def _draw_tabbar(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    index: int,
    extra_data: ExtraData,
) -> int:
    if tab.is_active:
        tab_fg = colors["active_fg"]
        tab_bg = colors["active_bg"]
    else:
        tab_fg = colors["fg"]
        tab_bg = colors["bg"]
    bar_bg = colors["bar_bg"]

    screen.cursor.fg, screen.cursor.bg = tab_bg, bar_bg
    screen.draw(symbols["separator_left"])

    screen.cursor.fg, screen.cursor.bg = tab_fg, tab_bg
    draw_title(draw_data, screen, tab, index)
    _draw_window_count(screen, tab.num_window_groups)

    screen.cursor.fg, screen.cursor.bg = tab_bg, bar_bg
    screen.draw(symbols["separator_right"])
    screen.draw(opts.tab_separator)

    return screen.cursor.x


###########################################################
######################## RIGHT TAB ########################
###########################################################


def _get_right_status_data():
    time_str = " " + datetime.now().strftime("%Y-%m-%d %H:%M")
    return time_str


def _draw_right(screen: Screen, is_last: bool, right_width: int = None) -> int:
    if not is_last:
        return screen.cursor.x
    draw_attributed_string(Formatter.reset, screen)

    time_str = _get_right_status_data()

    cells = [
        (colors["fg"], colors["bar_bg"], symbols["separator_left"]),
        (colors["accent"], colors["fg"], symbols["clock"]),
        (colors["fg"], colors["bg"], time_str),
    ]

    right_width = _calculate_right_width(cells)
    screen.cursor.x = screen.columns - right_width

    for fg, bg, content in cells:
        screen.cursor.fg = fg
        screen.cursor.bg = bg
        screen.draw(content)

    return screen.cursor.x


###########################################################
########################## MAIN ###########################
###########################################################


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    if index == 1:
        _draw_left(screen)

    _draw_tabbar(draw_data, screen, tab, index, extra_data)

    if is_last:
        _draw_right(screen, is_last)
    return screen.cursor.x
