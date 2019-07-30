local awful = require("awful")
local beautiful = require("beautiful")
local lain = require("lain")

local myvolume = { mt = {} }
local vstat = {}

function myvolume.new()
  local volume = lain.widget.pulse {
    settings = function()
      left = tonumber(volume_now.left)
      right = tonumber(volume_now.right)
      vlevel = ""
      if left ~= nil and right ~= nil then
        vlevel = (left + right) // 2
      elseif left == nil and right == nil then
        vlevel = "N/A"
      elseif left ~= nil then
        vlevel = left
      else
        vlevel = right
      end

      local font_color = beautiful.fg_normal
      if volume_now.muted == "yes" then
        font_color = beautiful.fg_urgent
      end

      widget:set_markup(lain.util.markup(font_color," ♫" .. vlevel))
      vstat = volume_now
    end
  }

  volume.widget:buttons(awful.util.table.join(
    awful.button({}, 1, function() -- left click
      awful.spawn("pavucontrol")
    end),
    awful.button({}, 2, function() -- middle click
      os.execute(string.format("pactl set-sink-volume %d 100%%", volume.device))
      volume.update()
    end),
    awful.button({}, 3, function() -- right click
      os.execute(string.format("pactl set-sink-mute %d toggle", volume.device))
      volume.update()
    end),
    awful.button({}, 4, function() -- scroll up
      os.execute(string.format("pactl set-sink-volume %d +1%%", volume.device))
      volume.update()
    end),
    awful.button({}, 5, function() -- scroll down
      os.execute(string.format("pactl set-sink-volume %d -1%%", volume.device))
      volume.update()
    end)
  ))

  local volume_t = awful.tooltip {
    objects = { volume.widget },
    border_width = 1,
    timer_function = function()
      local format = 
        "┌[Device %d %s]\n" ..
        "├LR:\t%s%% %s%%\n" ..
        "└Muted:\t%s"
      local msg = lain.util.markup.font("monospace",
        string.format(format, vstat.index, vstat.device, vstat.left, vstat.right, vstat.muted))
      return msg
    end
  }

  return volume
end

function myvolume.mt:__call(...)
  return myvolume.new(...)
end

return setmetatable(myvolume, myvolume.mt)
