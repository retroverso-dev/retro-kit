if not (RetroKitServer and RetroKitServer.config and RetroKitServer.config.debug) then
  return
end

local ui = RetroKitServer.ui
local tests = {}

-- ══════════════════════════════════════════
-- LOAD TEST MODULES
-- ══════════════════════════════════════════

-- Each module receives (tests, ui) and registers its handlers
local function loadTest(name, path)
  local fn = load(LoadResourceFile(GetCurrentResourceName(), path), "@" .. path)
  if fn then
    fn()(tests, ui)
  else
    print(("^1[retro-kit]^7 Failed to load debug module: %s"):format(name))
  end
end

loadTest("notification", "resource/server/debug/tests/notification.lua")
loadTest("alert",        "resource/server/debug/tests/alert.lua")
loadTest("progress",     "resource/server/debug/tests/progress.lua")
loadTest("context",      "resource/server/debug/tests/context.lua")
loadTest("textui",       "resource/server/debug/tests/textui.lua")
loadTest("dialog",       "resource/server/debug/tests/dialog.lua")

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