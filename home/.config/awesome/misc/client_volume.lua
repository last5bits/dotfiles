-- Change the volume of a particular window, based on PulseAudio's pactl
-- Alexey Zhikhartsev <last [digit five] bits at gmail dot com>
--
-- Put the following in your rc.lua:
-- local client_volume = require('client_volume')
--
-- And add these into the key bindings list:
-- awful.key({ modkey, "Ctrl"    }, "Up",      client_volume.up,
--          {description="client volume up", group="custom"}),
-- awful.key({ modkey, "Ctrl"    }, "Down",    client_volume.down,
--          {description="client volume up", group="custom"}),

local client_volume = {}

local awful = require("awful")
local naughty = require("naughty")

local delta = 5
local notif_id = nil

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
local function show_volume(output)
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
                notif_id = naughty.notify({ text = msg
                    , replaces_id = notif_id }).id
            end
        end
    end
end

local function up(output)
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            awful.spawn("pactl set-sink-input-volume " .. id .. " +" .. delta .. "%")
            awful.spawn.easy_async("pactl list sink-inputs", show_volume)
        end
    end
end

local function down(output)
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            awful.spawn("pactl set-sink-input-volume " .. id .. " -" .. delta .. "%")
            awful.spawn.easy_async("pactl list sink-inputs", show_volume)
        end
    end
end

function client_volume.up()
    awful.spawn.easy_async("pactl list sink-inputs", up)
end

function client_volume.down()
    awful.spawn.easy_async("pactl list sink-inputs", down)
end

return client_volume
