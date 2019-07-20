-- Control system audio via pulseaudio:
--   * System volume up/down
--   * Current client's volume up/down
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

function audio.client_up()
    awful.spawn.easy_async("pactl list sink-inputs", client_up)
end

function audio.client_down()
    awful.spawn.easy_async("pactl list sink-inputs", client_down)
end

return audio
