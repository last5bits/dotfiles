local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local lain = require("lain")

local mynet = { mt = {} }
local netstat = { no_internet = true }

function mynet.new(args)
  local ICON_DIR = awful.util.getdir("config") .. "/widgets/icons/"
  local wifi_weak_filename = ICON_DIR .. "wireless_0.png"
  local wifi_mid_filename = ICON_DIR .. "wireless_1.png"
  local wifi_good_filename = ICON_DIR .. "wireless_2.png"
  local wifi_great_filename = ICON_DIR .. "wireless_3.png"
  local wifi_noconnect_filename = ICON_DIR .. "wireless_noconnect.png"

  local wifi_na_filename = ICON_DIR .. "wireless_na.png"
  if args and args.wifi_hide_disconnected then
    local wifi_na = ""
  end
  local ethernet_filename = ICON_DIR .. "wired.png"

  local ethernet_na_filename = ""
  if args and not args.eth_hide_disconnected then
    ethernet_na_filename = ICON_DIR .. "wired_na.png"
  end

  local wifi_icon = wibox.widget.imagebox(wifi_na_filename)
  local eth_icon = wibox.widget.imagebox(ethernet_na_filename)

  local net = lain.widget.net {
    notify = "off",
    wifi_state = "on",
    eth_state = "on",
    settings = function()
      local eth0 = net_now.devices["eth0"]
      if eth0 then
        if eth0.ethernet then
          eth_icon:set_image(ethernet_filename)
        else
          eth_icon:set_image(ethernet_na_filename)
        end
      end

      local wlan0 = net_now.devices["wlan0"]
      if wlan0 then
        if wlan0.wifi then
          local signal = wlan0.signal
          if netstat.no_internet then
            wifi_icon:set_image(wifi_noconnect_filename)
          elseif signal < -83 then
            wifi_icon:set_image(wifi_weak_filename)
          elseif signal < -70 then
            wifi_icon:set_image(wifi_mid_filename)
          elseif signal < -53 then
            wifi_icon:set_image(wifi_good_filename)
          elseif signal >= -53 then
            wifi_icon:set_image(wifi_great_filename)
          end
        else
          wifi_icon:set_image(wifi_na_filename)
        end
      end

      awful.spawn.easy_async_with_shell("nc -z 8.8.8.8 53 >/dev/null 2>&1",
          function(_, _, _, exit_code)
              if not (exit_code == 0) then
                  netstat.no_internet = true
              else
                  netstat.no_internet = false
              end
          end)

      netstat = gears.table.join(netstat, net_now)
    end
  }

  local wifi_t = awful.tooltip {
    objects = { wifi_icon },
    border_width = 1,
    timer_function = function()
      local format =
        "┌[wlan0]\n" ..
        "├Signal:\t%s\n" ..
        "├Sent:   \t%s\n" ..
        "└Received:\t%s"
      local signal = "N/A"
      local sent = "N/A"
      local recv = "N/A"
      if netstat.devices["wlan0"] then
        local s = tonumber(netstat.devices["wlan0"].signal)
        if s then
          signal = math.floor(math.min(math.max(2 * (s + 100), 0), 100)) .. "%"
        end
        sent = netstat.devices["wlan0"].sent .. " kB"
        recv = netstat.devices["wlan0"].received .. " kB"
      end
      local msg = string.format(format, signal, sent, recv)
      return lain.util.markup.font("monospace", msg)
    end
  }

  return wifi_icon, eth_icon
end

function mynet.mt:__call(...)
  return mynet.new(...)
end

return setmetatable(mynet, mynet.mt)
-- vim: filetype=lua:expandtab:shiftwidth=2:tabstop=8:softtabstop=2:textwidth=80
