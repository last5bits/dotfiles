local awful = require("awful")
local lain = require("lain")

local mybat = { mt = {} }
local batstat = {}

function mybat.new()
  local mybattery = lain.widget.bat {
    timeout = 5,
    settings = function()
      widget:set_markup(" ↯" .. bat_now.perc)
      batstat = bat_now
    end
  }

  local mybattery_t = awful.tooltip {
    objects = { mybattery.widget },
    border_width = 1,
    timer_function = function()
      local msg = ""
      for i = 1, #batstat.n_status do
        local format =
          "┌[Battery %d]\n" ..
          "├Status:\t%s\n" ..
          "└Percentage:\t%s\n\n"
        msg = msg .. lain.util.markup.font("monospace 10", string.format(format,
          i - 1, batstat.n_status[i], batstat.n_perc[i]))
      end
      return msg .. lain.util.markup.font("monospace 10", "Time left:\t" .. batstat.time)
    end
  }

  return mybattery
end

function mybat.mt:__call(...)
  return mybat.new(...)
end

return setmetatable(mybat, mybat.mt)
