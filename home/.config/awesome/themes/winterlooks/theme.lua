---------------------------
-- Default awesome theme --
---------------------------

theme = {}
theme.dir = os.getenv("HOME") .. "/.config/awesome/themes"

theme.font          = "dejavu sans 8"

theme.bg_normal     = "#FFFFFF"
--theme.bg_normal     = "#e9e9e900"
theme.bg_focus      = "#b3b3b3"
theme.bg_urgent     = "#ff0000"
theme.bg_minimize   = theme.bg_normal

theme.fg_normal     = "#000000"
theme.fg_focus      = "#000000"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#3d3dff"

theme.border_width  = "1"
theme.border_normal = "#aaaaaa"
theme.border_focus  = "#000000" --"#3d3dff"
theme.border_marked = "#91231c"

theme.fg_notify     = "#ffffff"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Display the taglist squares
theme.taglist_squares_sel   = theme.dir .. "/winterlooks/taglist/squaref.png"
theme.taglist_squares_unsel = theme.dir .. "/winterlooks/taglist/square.png"

theme.tasklist_floating_icon = theme.dir .. "/winterlooks/tasklist/floating.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon = theme.dir .. "/winterlooks/submenu.png"
theme.menu_height = "15"
theme.menu_width  = "100"

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.chat_icon = theme.dir .. "/winterlooks/icons/chat.png"
theme.titlebar_close_button_normal = theme.dir .. "/winterlooks/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = theme.dir .. "/winterlooks/titlebar/close_focus.png"

theme.titlebar_ontop_button_normal_inactive = theme.dir .. "/winterlooks/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir .. "/winterlooks/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "/winterlooks/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = theme.dir .. "/winterlooks/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = theme.dir .. "/winterlooks/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir .. "/winterlooks/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "/winterlooks/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active  = theme.dir .. "/winterlooks/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = theme.dir .. "/winterlooks/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir .. "/winterlooks/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "/winterlooks/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active  = theme.dir .. "/winterlooks/titlebar/floating_focus_active.png"

theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/winterlooks/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/winterlooks/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "/winterlooks/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = theme.dir .. "/winterlooks/titlebar/maximized_focus_active.png"

theme.wallpaper_cmd = { "awsetbg -u feh " .. theme.dir .. "/winterlooks/background.png" }
theme.wallpaper = theme.dir .. "/winterlooks/background.png"

-- You can use your own layout icons like this:
theme.layout_fairh = theme.dir .. "/winterlooks/layouts/fairh.png"
theme.layout_fairv = theme.dir .. "/winterlooks/layouts/fairv.png"
theme.layout_floating  = theme.dir .. "/winterlooks/layouts/floating.png"
theme.layout_magnifier = theme.dir .. "/winterlooks/layouts/magnifier.png"
theme.layout_max = theme.dir .. "/winterlooks/layouts/max.png"
theme.layout_fullscreen = theme.dir .. "/winterlooks/layouts/fullscreen.png"
theme.layout_tilebottom = theme.dir .. "/winterlooks/layouts/tilebottom.png"
theme.layout_tileleft   = theme.dir .. "/winterlooks/layouts/tileleft.png"
theme.layout_tile = theme.dir .. "/winterlooks/layouts/tile.png"
theme.layout_tiletop = theme.dir .. "/winterlooks/layouts/tiletop.png"
theme.layout_spiral  = theme.dir .. "/winterlooks/layouts/spiral.png"
theme.layout_dwindle = theme.dir .. "/winterlooks/layouts/dwindle.png"

theme.awesome_icon = "/usr/share/awesome/icons/awesome16.png"

return theme
