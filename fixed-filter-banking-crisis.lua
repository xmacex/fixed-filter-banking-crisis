--    fixed filter bank
--                     ing crisis
--
--
-- E1 adjust some bands
-- E2 adjust some bands
-- E3 adjust some bands
--
-- crow
-- → 1 choose band or rq
-- → 2 set value
--
-- by xmacex

local WIDTH  = 128
local HEIGHT = 64

local MAXV = 10

local NFILTERS = 8

engine.name = 'FixedFilterBank'

g = grid.connect()

local osc_controller_host = nil
local OSC_CONTROLLER_PORT = 8002

local selected_param = 'amp0'

--- Lifecycle

function init()
   init_params()
   init_crow()
   init_grid()
   init_ui()

   monitor_level_when_script_was_started = params:get('monitor_level')
   params:set('monitor_level', -inf)

   osc.event = osc_remember_host
end

function init_params()
   params:add_taper('amp0', "amp0", 0, 1, 0.1)
   params:set_action('amp0', function(v) set_band(0, v) end)

   params:add_taper('amp1', "amp1", 0, 1, 0.3)
   params:set_action('amp1', function(v) set_band(1, v) end)

   params:add_taper('amp2', "amp2", 0, 1, 0)
   params:set_action('amp2', function(v) set_band(2, v) end)

   params:add_taper('amp3', "amp3", 0, 1, 0.5)
   params:set_action('amp3', function(v) set_band(3, v) end)

   params:add_taper('amp4', "amp4", 0, 1, 0)
   params:set_action('amp4', function(v) set_band(4, v) end)

   params:add_taper('amp5', "amp5", 0, 1, 0)
   params:set_action('amp5', function(v) set_band(5, v) end)

   params:add_taper('amp6', "amp6", 0, 1, 0.2)
   params:set_action('amp6', function(v) set_band(6, v) end)

   params:add_taper('amp7', "amp7", 0, 1, 0)
   params:set_action('amp7', function(v) set_band(7, v) end)

   params:add_control('rq', "rq", controlspec.RQ)
   params:set_action('rq', function(v) engine.rq(v)end)
   params:set('rq', 1)
end

function init_crow()
   crow.input[1].mode('window', {0, 1, 2, 3, 4, 5, 6, 7}, 0)
   crow.input[1].window = function(w)
      if w == 1 then
	 selected_param = 'rq'
      else
	 selected_param = 'amp'..w-2
      end
      crow.input[2].query()
   end

   crow.input[2].mode('none')
   crow.input[2].stream = process_crow_param_selection
end

-- Placeholder if I need it
function init_grid() return end

function init_ui()
   ui_metro = metro.init()
   ui_metro.time = 1.0 / 15
   ui_metro.event = function()
      redraw()
   end
   ui_metro:start()
end

function cleanup()
   if params:get('monitor_level') == -inf then
      params:set('monitor_level', monitor_level_when_script_was_started)
   end
end

--- paramater update

function set_band(band, value)
   engine.commands['amp'..band].func(value)
   grid_band(band, value)
   osc_update('amp'..band, value)
end

--- UI/screen

function redraw()
   screen.clear()
   draw_noise()
   draw_text()
   screen.update()
end

function draw_noise()
   local BWIDTH = WIDTH / NFILTERS
   for filter_i=0,NFILTERS-1 do
      local BCENTER = BWIDTH*filter_i+(BWIDTH/2)
      screen.level(util.round(util.linlin(0, 1, 1, 4, params:get('amp'..filter_i))))
      for spec=0, math.floor(params:get('amp'..filter_i)*100) do
	 screen.pixel(BCENTER + math.random(-BWIDTH/2, BWIDTH/2)*params:get('rq'), HEIGHT-math.random(HEIGHT))
      end
      screen:fill()
   end
end

function draw_text()
   screen.font_face(math.random(20))
   screen.font_size(20)
   screen.level(13)
   screen.text_center_rotate(WIDTH/2, HEIGHT/2+5, "€¥£", 35)
   screen.stroke()
end

--- UI/keys and encoders

function enc(n, d)
   for filter_i=0,NFILTERS-1,n+1 do
      params:delta('amp'..filter_i, d)
   end
end

--- UI/crow

function process_crow_param_selection(v)
   scaled_value = nil
   if selected_param == 'rq' then
      scaled_value = util.linlin(0, MAXV, params:get_range(selected_param)[2], params:get_range(selected_param)[1], v)
   else
      scaled_value = util.linlin(0, MAXV, params:get_range(selected_param)[1], params:get_range(selected_param)[2], v)
   end
   params:set(selected_param, scaled_value)
end

--- UI/grid

g.key = function(x, y, z)
   local band = x-1
   if z == 1 then
      if y == g.rows and params:get('amp'..band) <= 1/g.rows and params:get('amp'..band) > 0 then
	 params:set('amp'..band, 0)
      else
	 local value=util.linlin(1, g.rows+1, 1, 0, y)
	 params:set('amp'..band, value)
      end
   end
end

function grid_band(band, value)
   local x=band+1
   for i=1,g.rows do
      if i > g.rows*value then
	 g:led(x, g.rows-i+1, 0)
      else
	 g:led(x, g.rows-i+1, 5)
      end
   end
   g:refresh()
end

--- UI/OSC

function osc_remember_host(path, args, source)
  host, port = table.unpack(source)
  if host ~= '127.0.0.1' then
    if not osc_controller_host then -- update the OSC control surface
      osc_controller_host = host
      print("🎚🎚🎚🎚🎚🎚🎚🎚 refreshing the OSC️ surface")
      for filter_i=0,7 do
        osc_update('amp'..filter_i, params:get('amp'..filter_i))
      end
    end
    osc_controller_host = host
  end
end

function osc_update(param, value)
  if osc_controller_host then
    osc.send({osc_controller_host, OSC_CONTROLLER_PORT}, '/param/'..param, {value})
  end
end

-- Local Variables:
-- flycheck-luacheck-standards: ("lua51" "norns")
-- End:
