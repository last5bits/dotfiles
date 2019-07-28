-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Pop-up calendar
local cal = require("widgets/cal")
-- Battery indicator
local mybat = require('widgets/mybat')
-- Pulseaudio volume indicator
local myvolume = require('widgets/myvolume')
-- Choose the default pulseaudio sink
local sinker = require('widgets/sinker')
-- Change overall/client volume with pulseaudio
local audio = require('misc/audio')
-- Switch monitors
local xrandrer = require('widgets/xrandrer')
-- Network widgets for wireless/wired connections
local net_widgets = require("net_widgets")
local lain = require("lain")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notification {
        preset  = naughty.config.presets.critical,
        title   = "Oops, there were errors during startup!",
        message = awesome.startup_errors
    }
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notification {
            preset  = naughty.config.presets.critical,
            title   = "Oops, an error happened!",
            message = tostring(err)
        }

        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
--[[
   [ default_apps.lua should be similar to this
   [ local default_apps = {}
   [ function default_apps.get()
   [     return {
   [         terminal = "termite"
   [         , editor = os.getenv("EDITOR") or "vim"
   [         ...
   [     }
   [ end
   [ return default_apps
   ]]
default_apps_path = awful.util.getdir("config") .. "/" .. "default_apps.lua"
if awful.util.file_readable(default_apps_path) then
    local default_apps = require("default_apps")
    local apps = default_apps.get()

    terminal = apps["terminal"]
    editor = apps["editor"]
    display_off = apps["display_off"]
    web_browser = apps["web_browser"]
    wifi_manager = apps["wifi_manager"]
    email_client = apps["email_client"]
    shutdown_dialog = apps["shutdown_dialog"]
    xlocker = apps["xlocker"]
    screenshooter = apps["screenshooter"]

    -- Music player commands
    music_player = apps["music_player"]
    music_toggle = apps["music_toggle"]
    music_next   = apps["music_next"]
    music_prev   = apps["music_prev"]
else
    terminal = "urxvt"
    editor = os.getenv("EDITOR") or "vim"
    display_off = "dispoff"
    web_browser = "google-chrome-beta"
    wifi_manager = "wifi-menu"
    email_client = "thunderbird"
    shutdown_dialog = "farewell"
    xlocker = "slock"
    screenshooter = "flameshot gui"

    -- Music player commands
    music_player = "spotify"
    music_toggle = "playerctl play-pause"
    music_next   = "playerctl next"
    music_prev   = "playerctl previous"
end


-- Themes define colours, icons, and wallpapers
theme_dir = awful.util.getdir("config") .. "/themes/zenburn/"
beautiful.init(theme_dir .. "theme.lua")
gears.wallpaper.set("#000000")

sinker = sinker()
xrandrer = xrandrer()

net_wireless = net_widgets.wireless({indent = 0, font = "monospace", popup_position = "bottom_right", popup_signal = true, timeout = 3})
net_wired = net_widgets.indicator({interfaces = {"eth0"}, indent = 0, font = "monospace", popup_position = "bottom_right", timeout = 3, hidedisconnected = true})

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "open terminal", terminal }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create calendars
cal_args = { spacing = 0, start_sunday = true }
cal.register(mytextclock)
--month_calendar = awful.widget.calendar_popup.month(cal_args)
--month_calendar:attach( mytextclock, "br" )
year_calendar = awful.widget.calendar_popup.year(cal_args)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

screen.connect_signal("request::wallpaper", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

screen.connect_signal("request::desktop_decoration", function(s)
    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "bottom", screen = s })

    -- Create a battery widget; make the screen own it to avoid having
    -- multiple sets of batteries in the tooltip.
    s.mybattery = mybat()

    s.myvolume = myvolume()

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            --mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            s.mybattery,
            s.myvolume,
            net_wired,
            net_wireless,
            layout = wibox.layout.fixed.horizontal,
            --mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end)
    --, awful.button({ }, 4, awful.tag.viewnext)
    --, awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local function show_time_and_charge()
    --local os = os
    local time_text = os.date("%a %b %d, %H:%M")

    local handle = io.popen("acpi -b | head -n1 | cut -d' ' -f4")
    local charge_text  = handle:read("*a")
    charge_text = charge_text:sub(1, #charge_text - 1)
    handle:close()

    local notif_text = string.format("Charge: %s %s", charge_text, time_text)

    notif_id = naughty.notify({ text = notif_text
        , font = "sans 13"
        , replaces_id = notif_id
        , position = "bottom_right" }).id
end

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey            }, "Down", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey            }, "Up", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
--                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    -- Custom hotkeys
    awful.key({ modkey,           }, "a",      function () sinker:show() end,
              {description="change pulseaudio sink", group="custom"}),
    awful.key({ modkey,    "Mod1"}, "space",      show_time_and_charge,
              {description = "show current time and battery charge", group = "custom"}),
    awful.key({ modkey,           }, "d",      function () awful.spawn(display_off) end,
              {description = "turn display(s) off", group = "custom"}),
    awful.key({ modkey,           }, "F1",     function () awful.spawn(web_browser) end,
              {description = "run web browser", group = "custom"}),
    awful.key({ modkey,           }, "F5",     function () awful.spawn(music_player) end,
              {description = "run music player", group = "custom"}),
    awful.key({ modkey,           }, "F6",     function () awful.spawn(music_toggle) end,
              {description = "toggle play/pause", group = "custom"}),
    awful.key({ modkey,           }, "F7",     function () awful.spawn(music_prev) end,
              {description = "previous track", group = "custom"}),
    awful.key({ modkey, }, "c",      function () awful.spawn(music_toggle) end,
              {description = "toggle play/pause", group = "custom"}),
    awful.key({ modkey,           }, "F8",     function () awful.spawn(music_next) end,
              {description = "next track", group = "custom"}),
    awful.key({ modkey,           }, "F9",     function () awful.spawn(shutdown_dialog) end,
              {description = "run shutdown dialog", group = "custom"}),
    awful.key({ modkey,           }, "F12",    function () awful.spawn(xlocker) end,
              {description = "run screen locker", group = "custom"}),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.spawn(terminal .. " -e sh -c \"tmux attach || tmux new -s misc\"") end,
              {description = "open tmux", group = "custom"}),
    awful.key({                   }, "Print",  function () awful.spawn(screenshooter) end,
              {description = "make a screenshot", group = "custom"}),
    awful.key({ modkey, "Ctrl"    }, "Up",      audio.client_up,
              {description="client volume up", group="custom"}),
    awful.key({ modkey, "Ctrl"    }, "Down",    audio.client_down,
              {description="client volume down", group="custom"}),
    awful.key({ modkey, "Control" }, "c",  function () year_calendar:toggle() end,
              {description="show year calendar", group="custom"}),

    -- Multimedia keys
    -- Run the following to identify multimedia keys:
    -- xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
    awful.key({}, "XF86AudioMute", audio.toggle_mute),
    awful.key({}, "XF86AudioLowerVolume", audio.volume_down),
    awful.key({}, "XF86AudioRaiseVolume", audio.volume_up),
    awful.key({}, "XF86AudioMicMute", audio.toggle_mic_mute),
    awful.key({}, "XF86MonBrightnessDown", function () awful.spawn("xbacklight -dec 10") end),
    awful.key({}, "XF86MonBrightnessUp", function () awful.spawn("xbacklight -inc 10") end),
    awful.key({}, "XF86Display", function () xrandrer:show() end),
    awful.key({}, "XF86Tools", function () awful.spawn("toggle-pavucontrol") end),
    -- awful.key({}, "XF86Search", audio.switch_default_sink),
    -- awful.key({}, "XF86LaunchA", function () audio.client_switch_sink() end),
    awful.key({}, "XF86Explorer", function () awful.spawn("ignite") end),
    -- awful.key({}, "XF86ScreenSaver", function () awful.spawn(xlocker) end),
    -- awful.key({}, "XF86TouchpadToggle", function () awful.spawn("toggle-touchpad") end),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- {{{ Local globalkeys

-- A local module might look something like:
-- local gears = require("gears")
-- local awful = require("awful")
-- local _M = {}
-- function _M.get()
--     local globalkeys = gears.table.join(
--         awful.key({ modkey,           }, "e",      function () awful.spawn.raise_or_spawn("???") end,
--                   {description="Shhhhh", group="custom"})
--     )
--     return globalkeys
-- end
-- return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })

local local_keys_path = awful.util.getdir("config") .. "/local/globalkeys.lua"
if awful.util.file_readable(local_keys_path) then
  local local_keys = require("local/globalkeys")
  globalkeys = gears.table.join(globalkeys, local_keys())
end
-- }}}

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer",
          "gimp",
          "Farewell"
        },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    { rule = { class = "Firefox" },
      properties = { screen = 1, tag = "1", floating = false } },
    { rule = { class = "Steam" },
      properties = { screen = 1, tag = "7" } },
    { rule = { class = "qBittorrent", type="normal" },
      properties = { screen = 1, tag = "8", maximized = true } },
    { rule = { class = "spotify" },
      properties = { screen = 1, tag = "9", maximized = true } },
    { rule = { class = "OxygenNotIncluded" },
      properties = { floating = false } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

--local awful = require("awful")
--rules_spec = {
    --{ rule = { class = "assistant" },
      --properties = { tag = tags[screen.count()][2] } },
--}
--for key, val in ipairs(rules_spec) do
  --table.insert(awful.rules.rules, val)
--end

----autorun = true
--autorun = false
--autorunApps =
--{
    --"assistant"
--}
--if autorun then
	--for app = 1, #autorunApps do
		--awful.util.spawn(autorunApps[app])
	--end
--end

-- {{{ Local rules
rc_rules = awful.util.getdir("config") .. "/" .. "rules.lua"
if awful.util.file_readable(rc_rules) then
    dofile(rc_rules)
end
-- }}}
--
-- {{{ Autorun
rc_autorun = awful.util.getdir("config") .. "/" .. "autorun.lua"
if awful.util.file_readable(rc_autorun) then
    dofile(rc_autorun)
end
-- }}}
