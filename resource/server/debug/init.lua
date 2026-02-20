if not (RetroKitServer and RetroKitServer.config and RetroKitServer.config.debug) then
  return
end

local ui = RetroKitServer.ui
local tests = {}

-- Load all test modules
local modules = {
  "notification",
  "alert",
  "progress",
  "context",
  "textui",
  "dialog",
}

for _, mod in ipairs(modules) do
  local register = exports["retro-kit"]["__debug_" .. mod]
  if not register then
    local fn = LoadResourceFile(GetCurrentResourceName(), "resource/server/debug/tests/" .. mod .. ".lua")
    if fn then
      local chunk = load(fn, "@debug/tests/" .. mod .. ".lua")
      if chunk then
        chunk()(tests, ui)
      end
    end
  end
end

-- ══════════════════════════════════════════
-- COMMAND REGISTRATION
-- ══════════════════════════════════════════
RegisterCommand("test", function(source, args)
  local component = (args[1] or "notification"):lower()
  local handler = tests[component]

  if handler then
    handler(source, args)
  else
    ui.notify(source, {
      style = "error",
      title = "Error",
      description = ("Unknown component: %s"):format(component),
    })
  end
end, false)

print("^2[Retro Kit]^7 Debug mode enabled! Use /test [alert|notification|progress|context|textui|dialog] [type]")