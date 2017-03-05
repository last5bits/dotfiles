local client_volume = {}

local awful = require("awful")
local naughty = require("naughty")

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

local function up(output)
    --naughty.notify({text = output})
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            awful.spawn("pactl set-sink-input-volume " .. id .. " +5%")
        end
    end
end

local function down(output)
    --naughty.notify({text = output})
    local c = client.focus
    if c then
        id = get_sink_input_id(output, c.pid)
        if id ~= -1 then
            awful.spawn("pactl set-sink-input-volume " .. id .. " -5%")
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
