local awful = require("awful")
local lain = require("lain")
local beautiful = require("beautiful")

local mycal = { mt = {} }

function mycal.new(args)
  local cal = lain.widget.cal {
    attach_to = { args.attach_to },
    week_start = 1,
    followtag = true,
    icons = "",
    notification_preset = {
      fg = beautiful.fg_normal,
      bg = beautiful.bg_normal,
      border_color = beautiful.tooltip_border_color,
      font = "Monospace 10",
      position = "bottom_right"
    }
  }

  return cal
end

function mycal.mt:__call(...)
  return mycal.new(...)
end

return setmetatable(mycal, mycal.mt)
-- vim: filetype=lua:expandtab:shiftwidth=2:tabstop=8:softtabstop=2:textwidth=80
