-- Control system audio via pulseaudio:
--   * System volume up/down
--   * Current client's volume
--   * Switch the default sink (e.g., speakers <-> HDMI)
--   * Switch the current client's sink
-- Copyright: Alexey Zhikhartsev <last [digit five] bits [at] gmail [dot] com>

local audio = {}

local awful = require("awful")
local naughty = require("naughty")

local delta = 5
local notif_id = nil
local client_notif_id = nil

local function show_volume(output)
    local volume_level = string.match(output, "(%d+)")
    local volume_msg = "Volume is at " .. volume_level .. "%"
    notif_id = naughty.notify({ text = volume_msg, replaces_id = notif_id }).id
end

local function get_sink_menu(get_cmd, get_msg)
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
         local sink_name = string.match(line, "^[%d]+ \".+\" \"(.+)\"")
         local msg = get_msg(sink_name)

         -- Callback command
         local sink = string.match(line, "^[%d]+ \"(.+)\" \".+\"")
         local cmd = get_cmd(id, sink)

         table.insert(menu, {msg, {function() awful.spawn(cmd) end}})
      end
   end

   return menu
end

-- Courtesy of https://coronalabs.com/blog/2013/04/16/lua-string-magic/
function string:split( inSplitPattern, outResults )
   if not outResults then
      outResults = {}
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

-- Parse the pactl output and return sink input id
-- I.e., Sink Input #<NUM> -- return <NUM>
-- Return -1 if pid not found
local function get_sink_input_id(output, pid)
    lines = output:split('\n')
    sink_input_id = nil
    volume = nil
    for _, line in pairs(lines) do
        -- Extract Sink Input #
        if string.find(line, "Sink Input #") then
            sink_input_id = string.match(line, "Sink Input #(%d+)")
        end

        -- Extract the associated pid
        if string.find(line, 'application.process.id =') then
            spid = string.match(line, '.*application.process.id = "(%d+)"')
            if pid == tonumber(spid) then
                return tonumber(sink_input_id)
            end
        end
    end
    return -1
end

-- Parse `output` and show a notification with the volume of the current client
local function show_client_volume(output)
    local c = client.focus
    if c == nil then
        return
    end

    pid = c.pid
    lines = output:split('\n')
    volume = nil
    for _, line in pairs(lines) do
        -- Extract current volume
        if string.find(line, "Volume") then
            volume = string.match(line, ".* (%d+)%%.*")
        end

        -- Extract the associated pid
        if string.find(line, 'application.process.id =') then
            spid = string.match(line, '.*application.process.id = "(%d+)"')
            if pid == tonumber(spid) then
                msg = string.format("Client's volume is at %s%%", volume)
                client_notif_id = naughty.notify({ text = msg,
                   replaces_id = client_notif_id }).id
            end
        end
    end
end

local function client_up(output)
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            awful.spawn("pactl set-sink-input-volume " .. id .. " +" .. delta .. "%")
            awful.spawn.easy_async("pactl list sink-inputs", show_client_volume)
        end
    end
end

local function client_down(output)
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            awful.spawn("pactl set-sink-input-volume " .. id .. " -" .. delta .. "%")
            awful.spawn.easy_async("pactl list sink-inputs", show_client_volume)
        end
    end
end

local function switch_client_sink(output)
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            -- naughty.notify({ text = string.format("%d!", id) })
            local pamixer = io.popen("pamixer --list-sinks")

            local menu = get_sink_menu(function (id, sink)
                  return string.format("pactl move-sink-input %d %s", id, sink)
               end,
               function (sink_name)
                  return string.format("Client's default sink: %s", sink_name)
               end)

            -- Iterate over the menu
            local timeout = 2
            local menu_iterator = require("lain.util.menu_iterator")
            local card_icon_path = "/usr/share/icons/gnome/48x48/devices/audio-card.png"
            menu_iterator.iterate(menu, timeout, card_icon_path)
        end
    end
end

--[[ Public functions ]]

function audio.volume_up()
    awful.spawn("pamixer --allow-boost --gamma 2.0 --increase 5")
    awful.spawn.easy_async("pamixer --get-volume", show_volume)
end

function audio.volume_down()
    awful.spawn("pamixer --allow-boost --gamma 2.0 --decrease 5")
    awful.spawn.easy_async("pamixer --get-volume", show_volume)
end

function audio.toggle_mute()
    awful.spawn("pamixer --toggle-mute")
end

function audio.toggle_mic_mute()
    awful.spawn("pamixer --default-source --toggle-mute")
end

function audio.switch_default_sink()
   local pamixer = io.popen("pamixer --list-sinks")

   -- Compile a sink menu
   local menu = get_sink_menu(function (_, sink)
         return string.format("pacmd set-default-sink %s", sink)
      end,
      function (sink_name)
         return string.format("Default sink: %s", sink_name)
      end)

   -- Iterate over the menu
   local timeout = 2
   local menu_iterator = require("lain.util.menu_iterator")
   local card_icon_path = "/usr/share/icons/gnome/48x48/devices/audio-card.png"
   menu_iterator.iterate(menu, timeout, card_icon_path)
end

function audio.client_up()
    awful.spawn.easy_async("pactl list sink-inputs", client_up)
end

function audio.client_down()
    awful.spawn.easy_async("pactl list sink-inputs", client_down)
end

function audio.client_switch_sink()
    awful.spawn.easy_async("pactl list sink-inputs", switch_client_sink)
end

return audio
