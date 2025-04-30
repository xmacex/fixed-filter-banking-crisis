--    fixed filter bank
--                     ing crisis
--
--
-- E1 adjust some bands
-- E2 adjust some bands
-- E3 adjust some bands
--
-- by xmacex

WIDTH  = 128
HEIGHT = 64

NFILTERS = 8

engine.name = 'FixedFilterBank'

--- Lifecycle

function init()
   init_params()
   init_ui()

   -- audio.level_monitor(0) -- FIXME mixer does not follow somehow, confusing
   monitor_level_when_script_was_started = params:get('monitor_level')
   params:set('monitor_level', -inf)
end

function init_params()
   params:add_taper('amp0', "amp0", 0, 1, 0.1)
   params:set_action('amp0', function(v) engine.amp0(v) end)

   params:add_taper('amp1', "amp1", 0, 1, 0.3)
   params:set_action('amp1', function(v) engine.amp1(v) end)

   params:add_taper('amp2', "amp2", 0, 1, 0)
   params:set_action('amp2', function(v) engine.amp2(v) end)

   params:add_taper('amp3', "amp3", 0, 1, 0.5)
   params:set_action('amp3', function(v) engine.amp3(v) end)

   params:add_taper('amp4', "amp4", 0, 1, 0)
   params:set_action('amp4', function(v) engine.amp4(v) end)

   params:add_taper('amp5', "amp5", 0, 1, 0)
   params:set_action('amp5', function(v) engine.amp5(v) end)

   params:add_taper('amp6', "amp6", 0, 1, 0.2)
   params:set_action('amp6', function(v) engine.amp6(v) end)

   params:add_taper('amp7', "amp7", 0, 1, 0)
   params:set_action('amp7', function(v) engine.amp7(v) end)
end

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
      screen.level(util.round((params:get("amp"..filter_i))+1)*2)
      for spec=0, math.floor(params:get("amp"..filter_i)*100) do
         screen.pixel(BWIDTH*filter_i + math.random(BWIDTH), HEIGHT-math.random(HEIGHT))
      end
      screen:fill()
   end
end

function draw_text()
   screen.font_face(math.random(20))
   screen.font_size(20)
   screen.level(5)
   screen.text_center_rotate(WIDTH/2, HEIGHT/2+5, "€¥£", 35)
   screen.stroke()
end

--- UI/keys and encoders

function enc(n, d)
   for filter_i=0,NFILTERS-1,n+1 do
      params:delta("amp"..filter_i, d)
   end
end
