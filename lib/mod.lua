local mod = require 'core/mods'
local fx  = require("fx/lib/fx")

local FxFfbc = fx:new{
    subpath = "/fx_ffbc"
}

function FxFfbc:add_params()
    params:add_group("fx_ffbc", "FX FFBC", 9+2)
    FxFfbc:add_slot("fx_ffbc_slot", "slot")
    FxFfbc:add_taper("fx_ffbc_amp0", "amp0", "amp0", 0, 1, 0.1)
    FxFfbc:add_taper("fx_ffbc_amp1", "amp1", "amp1", 0, 1, 0.3)
    FxFfbc:add_taper("fx_ffbc_amp2", "amp2", "amp2", 0, 1, 0.0)
    FxFfbc:add_taper("fx_ffbc_amp3", "amp3", "amp3", 0, 1, 0.5)
    FxFfbc:add_taper("fx_ffbc_amp4", "amp4", "amp4", 0, 1, 0.0)
    FxFfbc:add_taper("fx_ffbc_amp5", "amp5", "amp5", 0, 1, 0.0)
    FxFfbc:add_taper("fx_ffbc_amp6", "amp6", "amp6", 0, 1, 0.2)
    FxFfbc:add_taper("fx_ffbc_amp7", "amp7", "amp7", 0, 1, 0.0)
    FxFfbc:add_control("fx_ffbc_rq", "rq", "rq", controlspec.RQ)
end

mod.hook.register("script_pre_init", "ffbc mod pre init", function()
                  FxFfbc:install()
end)

mod.hook.register("script_post_cleanup", "ffbc mod post cleanup", function()
end)

return FxFfbc
