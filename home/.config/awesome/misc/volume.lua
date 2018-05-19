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

return volume
