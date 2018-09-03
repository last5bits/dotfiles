local volume = {}

local awful = require("awful")
local naughty = require("naughty")

local delta = 5
local notif_id = nil

local function show_volume(output)
    local volume_level = string.match(output, "(%d+)")
    local volume_msg = "Volume is at " .. volume_level .. "%"
    notif_id = naughty.notify({ text = volume_msg, replaces_id = notif_id }).id
end

function volume.up()
    awful.spawn("pamixer --allow-boost --gamma 2.0 --increase 5")
    awful.spawn.easy_async("pamixer --get-volume", show_volume)
end

function volume.down()
    awful.spawn("pamixer --allow-boost --gamma 2.0 --decrease 5")
    awful.spawn.easy_async("pamixer --get-volume", show_volume)
end

function volume.toggle_mute()
    awful.spawn("pamixer --toggle-mute")
end

function volume.mic_toggle_mute()
    awful.spawn("pamixer --default-source --toggle-mute")
end

function volume.switch_default_sink()
   local pamixer = io.popen("pamixer --list-sinks")

   -- Compile a sink menu
   local menu = {}
   for line in pamixer:lines() do
      -- [alex@lenovski ~]$ pamixer --list-sinks
      -- Sinks:
      -- 0 "alsa_output.pci-0000_00_1b.0.analog-stereo" "Built-in Audio Analog Stereo"
      -- 1 "alsa_output.pci-0000_00_03.0.hdmi-stereo" "Built-in Audio Digital Stereo (HDMI)"
      if string.match(line, "^[%d+]") then
         -- Notification message
         local sink_name = string.match(line, "^[%d+] \".+\" \"(.+)\"")
         local msg = string.format("Default sink: %s", sink_name)

         -- Callback command
         local sink = string.match(line, "^[%d+] \"(.+)\" \".+\"")
         local cmd = string.format("pacmd set-default-sink %s", sink)

         table.insert(menu, {msg, {function() awful.spawn(cmd) end}})
      end
   end

   -- Iterate over the menu
   local timeout = 2
   local menu_iterator = require("lain.util.menu_iterator")
   local card_icon_path = "/usr/share/icons/gnome/48x48/devices/audio-card.png"
   menu_iterator.iterate(menu, timeout, card_icon_path)
end

return volume
