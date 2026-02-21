local config = _G.Config or {}
local bridgeConfig = config.Bridge or {}

Bridge = {
  framework = nil,
  inventory = nil,
  target = nil,
}

-- ══════════════════════════════════════════
-- AUTO-DETECTION
-- ══════════════════════════════════════════

local function isResourceStarted(name)
  return GetResourceState(name) == 'started'
end

local function detectTarget()
  local configured = bridgeConfig.target or "auto"
  configured = configured:lower()

  if configured == "auto" then
    if isResourceStarted("ox_target") then
      return "ox"
    elseif isResourceStarted("qb-target") then
      return "qb"
    else
      return "none"
    end
  end

  local aliases = {
    ["ox_target"] = "ox",
    ["ox"]        = "ox",
    ["qb-target"] = "qb",
    ["qb"]        = "qb",
    ["none"]      = "none",
    ["disabled"]  = "none",
    ["false"]     = "none",
  }

  return aliases[configured] or "none"
end

local function detectFramework()
  local configured = bridgeConfig.framework or "auto"
  configured = configured:lower()

  if configured == "auto" then
    if isResourceStarted("qb-core") then
      return "qbcore"
    elseif isResourceStarted("es_extended") then
      return "esx"
    elseif isResourceStarted("qbx_core") then
      return "qbox"
    elseif isResourceStarted("vrp") then
      return "vrpex"
    else
      return "none"
    end
  end

  local aliases = {
    ["qbcore"]        = "qbcore",
    ["qb-core"]       = "qbcore",
    ["qb"]            = "qbcore",
    ["esx"]           = "esx",
    ["es_extended"]   = "esx",
    ["qbox"]          = "qbox",
    ["qbx"]           = "qbox",
    ["qbx_core"]      = "qbox",
    ["vrpex"]         = "vrpex",
    ["vrp"]           = "vrpex",
    ["none"]          = "none",
    ["disabled"]      = "none",
  }

  return aliases[configured] or "none"
end

local function detectInventory()
  local configured = bridgeConfig.inventory or "auto"
  configured = configured:lower()

  if configured == "auto" then
    if isResourceStarted("ox_inventory") then
      return "ox_inventory"
    elseif isResourceStarted("qb-inventory") then
      return "qb-inventory"
    elseif isResourceStarted("qs-inventory") then
      return "qs-inventory"
    elseif isResourceStarted("es_extended") then
      return "esx"
    else
      return "none"
    end
  end

  local aliases = {
    ["ox_inventory"]  = "ox_inventory",
    ["ox"]            = "ox_inventory",
    ["qb-inventory"]  = "qb-inventory",
    ["qb"]            = "qb-inventory",
    ["qs-inventory"]  = "qs-inventory",
    ["qs"]            = "qs-inventory",
    ["esx"]           = "esx",
    ["es_extended"]   = "esx",
    ["none"]          = "none",
    ["disabled"]      = "none",
  }

  return aliases[configured] or "none"
end

-- ══════════════════════════════════════════
-- LOADER
-- ══════════════════════════════════════════

local context = IsDuplicityVersion() and "server" or "client"

local function loadBridge(bridgeType, bridgeName)
  -- Try context-specific file first (client.lua / server.lua)
  local path = ('resource/bridge/%s/%s/%s.lua'):format(bridgeType, bridgeName, context)
  local src = LoadResourceFile(GetCurrentResourceName(), path)

  -- Fallback to shared.lua
  if not src then
    path = ('resource/bridge/%s/%s/shared.lua'):format(bridgeType, bridgeName)
    src = LoadResourceFile(GetCurrentResourceName(), path)
  end

  if not src then
    if config.debug then
      print(("^3[retro-kit]^7 Bridge file not found: %s/%s (%s)"):format(bridgeType, bridgeName, context))
    end
    return nil
  end

  local chunk, err = load(src, ('@@retro-kit/bridge/%s/%s'):format(bridgeType, bridgeName))
  if not chunk then
    print(("^1[retro-kit]^7 Bridge load error (%s/%s): %s"):format(bridgeType, bridgeName, err))
    return nil
  end

  local ok, result = pcall(chunk)
  if not ok then
    print(("^1[retro-kit]^7 Bridge runtime error (%s/%s): %s"):format(bridgeType, bridgeName, result))
    return nil
  end

  return result
end

-- ══════════════════════════════════════════
-- INITIALIZE
-- ══════════════════════════════════════════

CreateThread(function()
  -- Target (client-only)
  if context == "client" then
    local targetName = detectTarget()
    Bridge.target = loadBridge("targets", targetName)

    if Bridge.target then
      if config.debug then
        print(("^2[retro-kit]^7 Target bridge loaded: %s"):format(targetName))
      end
    else
      print(("^3[retro-kit]^7 No target bridge available (tried: %s), loading fallback"):format(targetName))
      Bridge.target = loadBridge("targets", "none")
    end
  end

  -- Framework
  local frameworkName = detectFramework()
  Bridge.framework = loadBridge("framework", frameworkName)

  if Bridge.framework then
    if config.debug then
      print(("^2[retro-kit]^7 Framework bridge loaded: %s (%s)"):format(frameworkName, context))
    end
  else
    if config.debug then
      print(("^3[retro-kit]^7 No framework bridge available (tried: %s)"):format(frameworkName))
    end
  end

  -- Inventory
  local inventoryName = detectInventory()
  Bridge.inventory = loadBridge("inventory", inventoryName)

  if Bridge.inventory then
    if config.debug then
      print(("^2[retro-kit]^7 Inventory bridge loaded: %s (%s)"):format(inventoryName, context))
    end
  else
    if config.debug then
      print(("^3[retro-kit]^7 No inventory bridge available (tried: %s)"):format(inventoryName))
    end
  end

  if config.debug then
    print("^2[retro-kit]^7 Bridge initialization complete")
  end
end)