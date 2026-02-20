if not (_G.Config or {}).debug then return end

local tests = {}
local ui = {}

-- ══════════════════════════════════════════
-- UI FUNCTIONS
-- ══════════════════════════════════════════

ui.notify = function(src, data)
  TriggerClientEvent("retro-kit:notify", src, data)
end

ui.alert = function(src, data)
  TriggerClientEvent("retro-kit:sendAlert", src, data)
end

ui.progress = function(src, data, cb)
  if cb then
    local eventName = "retro-kit:debug:progressResponse:" .. tostring(src) .. ":" .. tostring(math.random(100000))
    RegisterNetEvent(eventName)
    local handler
    handler = AddEventHandler(eventName, function(cancelled)
      if handler then RemoveEventHandler(handler) end
      cb(cancelled)
    end)
    data._responseEvent = eventName
  end
  TriggerClientEvent("retro-kit:progress", src, data)
end

ui.circleProgress = function(src, data, cb)
  if cb then
    local eventName = "retro-kit:debug:circleProgressResponse:" .. tostring(src) .. ":" .. tostring(math.random(100000))
    RegisterNetEvent(eventName)
    local handler
    handler = AddEventHandler(eventName, function(cancelled)
      if handler then RemoveEventHandler(handler) end
      cb(cancelled)
    end)
    data._responseEvent = eventName
  end
  TriggerClientEvent("retro-kit:circleProgress", src, data)
end

ui.textUi = function(src, data)
  TriggerClientEvent("retro-kit:textUi", src, data)
end

ui.textUiHide = function(src)
  TriggerClientEvent("retro-kit:textUiHide", src)
end

ui.registerContext = function(src, id, data, clickCallbacks)
  RetroKitServer.ui.registerContext(src, id, data, clickCallbacks)
end

ui.showContext = function(src, id)
  RetroKitServer.ui.showContext(src, id)
end

ui.dialog = function(src, data)
  local p = promise.new()

  RegisterNetEvent("retro-kit:dialogResult")
  local handler
  handler = AddEventHandler("retro-kit:dialogResult", function(result)
    if source ~= src then return end
    RemoveEventHandler(handler)
    p:resolve(result)
  end)

  TriggerClientEvent("retro-kit:openDialog", src, data)

  return Citizen.Await(p)
end

-- ══════════════════════════════════════════
-- LOAD TEST FILES
-- ══════════════════════════════════════════

local testFiles = {
  "alert",
  "context",
  "dialog",
  "notification",
  "progress",
  "textui",
  "target",
  "inventory",
}

for _, name in ipairs(testFiles) do
  local path = ("resource/server/debug/tests/%s.lua"):format(name)
  local fileSrc = LoadResourceFile(GetCurrentResourceName(), path)
  if fileSrc then
    local chunk, err = load(fileSrc, ("@@retro-kit/debug/tests/%s"):format(name))
    if chunk then
      local ok, loader = pcall(chunk)
      if ok and type(loader) == "function" then
        loader(tests, ui)
        print(("^2[retro-kit]^7 Debug test loaded: %s"):format(name))
      else
        print(("^1[retro-kit]^7 Debug test error (%s): %s"):format(name, tostring(loader)))
      end
    else
      print(("^1[retro-kit]^7 Debug test parse error (%s): %s"):format(name, err))
    end
  else
    print(("^3[retro-kit]^7 Debug test file not found: %s"):format(name))
  end
end

-- ══════════════════════════════════════════
-- REGISTER COMMAND
-- ══════════════════════════════════════════

RegisterCommand("retro", function(source, args)
  local src = source
  local testName = args[1]

  if not testName then
    print("^3[retro-kit]^7 Available tests:")
    for name, _ in pairs(tests) do
      print(("  - %s"):format(name))
    end
    return
  end

  local test = tests[testName]
  if not test then
    print(("^1[retro-kit]^7 Test '%s' not found"):format(testName))
    return
  end

  local ok, err = pcall(test, src, args)
  if not ok then
    print(("^1[retro-kit]^7 Test '%s' failed: %s"):format(testName, err))
  end
end, false)

print("^2[retro-kit]^7 Debug commands registered. Use /retro <test> to run tests.")