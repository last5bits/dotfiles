-- A pop-up window to pick a pulseaudio sink
-- Copyright: Alexey Zhikhartsev <last [digit five] bits [at] gmail [dot] com>

local setmetatable = setmetatable
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")

local module = {}

local function get_sinks()
  local sinks = {}
  local pamixer = io.popen("pamixer --list-sinks")
  for line in pamixer:lines() do
    -- [alex@lenovski ~]$ pamixer --list-sinks
    -- Sinks:
    -- 0 "alsa_output.pci-0000_00_1b.0.analog-stereo" "Built-in Audio Analog Stereo"
    -- 1 "alsa_output.pci-0000_00_03.0.hdmi-stereo" "Built-in Audio Digital Stereo (HDMI)"
    if string.match(line, "^[%d+]") then
      -- Notification message
      local sink_full = string.match(line, "^[%d+] \"(.+)\" \".+\"")
      local sink_title = string.match(line, "^[%d+] \".+\" \"(.+)\"")
      table.insert(sinks, { full_name = sink_full, title = sink_title })
    end
  end
  return sinks
end

local function new(args)
  local l = wibox.layout.fixed.vertical()

  local pop = awful.popup {
    widget = {
      {
        layout = l
      },
      margins = 5,
      widget  = wibox.container.margin
    },
    border_color = beautiful.fg_normal,
    border_width = 2,
    placement    = awful.placement.centered,
    visible      = false,
    ontop        = true,
  }

  pop.cur_item = 0
  pop.num_items = 0
  pop.widgets = {}

  function pop:set_default_sink(sink_full_name)
    awful.spawn("set-default-sink " .. sink_full_name)
    self.visible = false
  end

  function pop:update_sinker()
    l:reset()
    self.widgets = {}
    self.num_items = 0
    self.cur_item = 0

    for _, sink in pairs(get_sinks()) do
      local w = wibox.widget{
        markup = sink.title,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
      }
      w:buttons(awful.util.table.join(
      awful.button({ }, 1, function()
        pop:set_default_sink(sink.full_name)
      end)))

      local bg = wibox.container.background()
      bg.widget = w
      bg.sink_full_name = sink.full_name

      l:add(bg)
      self.widgets[self.num_items] = bg
      self.num_items = self.num_items + 1
    end
  end

  function pop:set_current_item(item_no)
    self.widgets[self.cur_item].bg = beautiful.bg_normal
    self.widgets[self.cur_item].fg = beautiful.fg_normal
    self.cur_item = item_no
    self.widgets[self.cur_item].bg = beautiful.bg_focus
    self.widgets[self.cur_item].fg = beautiful.fg_focus
  end

  function pop:next_item()
    new_cur_item = (self.cur_item + 1) % self.num_items
    pop:set_current_item(new_cur_item)
  end

  function pop:run_keygrabber()
    local grabber = awful.keygrabber.run(function(_, key, event)
      if event == "release" then return end
      if key then
        if key == "Tab" then
          pop:next_item()
        elseif key == "Return" then
          sink_full_name = self.widgets[self.cur_item].sink_full_name
          pop:set_default_sink(sink_full_name)
        else
          pop.visible = false
          awful.keygrabber.stop(grabber)
        end
      end
    end)
  end

  function pop:show()
    pop:update_sinker()
    if self.num_items == 0 then
      naughty.notification {
          title   = "Error",
          message = "No pulseaudio sinks found!"
      }
      return
    end
    pop:set_current_item(0)
    pop:run_keygrabber()
    pop.visible = true
  end

  return pop
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
