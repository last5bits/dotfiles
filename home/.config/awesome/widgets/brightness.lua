--Courtesy of https://github.com/streetturtle

local wibox = require("wibox")
local awful = require("awful")
local gears = require("gears")
local watch = require("awful.widget.watch")

brightness_widget = wibox.widget.textbox()

brightness_icon = wibox.widget {
    {
        image = "/usr/share/icons/Adwaita/scalable/status/display-brightness-symbolic.svg",
        widget = wibox.widget.imagebox,
    },
    layout = wibox.container.margin(brightness_icon, 0, 2, 3, 3)
}

watch(
    "xbacklight -get", 1,
    function(widget, stdout, stderr, exitreason, exitcode)
        local brightness_level = tonumber(string.format("%.0f", stdout))
        brightness_widget:set_text(brightness_level)
    end
)
