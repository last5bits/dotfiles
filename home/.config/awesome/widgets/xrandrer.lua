-- A pop-up window to pick a monitor configuration.
-- Copyright: Alexey Zhikhartsev <last [digit five] bits [at] gmail [dot] com>

local setmetatable = setmetatable
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local xrandr = require('misc/xrandr')
local gears = require("gears")

local module = {}

local function get_configs()
  local configs = {}
  menu = xrandr.menu()
  for i = 1, #menu do
    label, command = unpack(menu[i])
    table.insert(configs, { label = label, command = command })
  end
  return configs
end

local function new(args)
  local l = wibox.layout.fixed.vertical()

  local pop = awful.popup {
    widget = {
      {
        {
          text   = 'dummy',
          widget = wibox.widget.textbox
        },
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

  pop.num_items = 0
  pop.cur_item = 1
  pop.widgets = {}

  function pop:set_config(command)
    awful.spawn(command)
    self.visible = false
  end

  function pop:update_widget()
    l:reset()
    self.widgets = {}
    self.num_items = 0
    self.cur_item = 1

    for _, config in pairs(get_configs()) do
      local w = wibox.widget{
        markup = config.label,
        align  = 'center',
        valign = 'center',
        widget = wibox.widget.textbox
      }
      w:buttons(awful.util.table.join(
      awful.button({ }, 1, function()
        pop:set_config(config.command)
      end)))

      local bg = wibox.container.background()
      bg.widget = w
      bg.command = config.command

      l:add(bg)
      self.widgets[self.num_items + 1] = bg
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
    new_cur_item = gears.math.cycle(self.num_items, self.cur_item + 1)
    pop:set_current_item(new_cur_item)
  end

  function pop:run_keygrabber()
    local grabber = awful.keygrabber.run(function(_, key, event)
      if event == "release" then return end
      if key then
        if key == "Tab" then
          pop:next_item()
        elseif key == "Return" then
          command = self.widgets[self.cur_item].command
          pop:set_config(command)
        else
          pop.visible = false
          awful.keygrabber.stop(grabber)
        end
      end
    end)
  end

  function pop:show()
    pop:update_widget()
    if self.num_items == 0 then
      naughty.notification {
          title   = "Error",
          message = "No monitors found! How are you even seeing this?"
      }
      return
    end
    pop:set_current_item(1)
    pop:run_keygrabber()
    pop.visible = true
  end

  return pop
end

return setmetatable(module, { __call = function(_, ...) return new(...) end })
