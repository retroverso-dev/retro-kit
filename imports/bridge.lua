retro = retro or {}
retro.bridge = retro.bridge or {}

-- ══════════════════════════════════════════
-- TARGET
-- ══════════════════════════════════════════

retro.bridge.target = {}

local function getTarget()
  return exports['retro-kit']:GetBridgeTarget()
end

function retro.bridge.target.addEntity(entities, options)
  local t = getTarget()
  if t then t.addEntity(entities, options) end
end

function retro.bridge.target.removeEntity(entities, optionNames)
  local t = getTarget()
  if t then t.removeEntity(entities, optionNames) end
end

function retro.bridge.target.addModel(models, options)
  local t = getTarget()
  if t then t.addModel(models, options) end
end

function retro.bridge.target.removeModel(models, optionNames)
  local t = getTarget()
  if t then t.removeModel(models, optionNames) end
end

function retro.bridge.target.addGlobalPlayer(options)
  local t = getTarget()
  if t then t.addGlobalPlayer(options) end
end

function retro.bridge.target.removeGlobalPlayer(optionNames)
  local t = getTarget()
  if t then t.removeGlobalPlayer(optionNames) end
end

function retro.bridge.target.addGlobalPed(options)
  local t = getTarget()
  if t then t.addGlobalPed(options) end
end

function retro.bridge.target.removeGlobalPed(optionNames)
  local t = getTarget()
  if t then t.removeGlobalPed(optionNames) end
end

function retro.bridge.target.addGlobalVehicle(options)
  local t = getTarget()
  if t then t.addGlobalVehicle(options) end
end

function retro.bridge.target.removeGlobalVehicle(optionNames)
  local t = getTarget()
  if t then t.removeGlobalVehicle(optionNames) end
end

function retro.bridge.target.addGlobalObject(options)
  local t = getTarget()
  if t then t.addGlobalObject(options) end
end

function retro.bridge.target.removeGlobalObject(optionNames)
  local t = getTarget()
  if t then t.removeGlobalObject(optionNames) end
end

function retro.bridge.target.addBoxZone(params)
  local t = getTarget()
  if t then t.addBoxZone(params) end
end

function retro.bridge.target.addSphereZone(params)
  local t = getTarget()
  if t then t.addSphereZone(params) end
end

function retro.bridge.target.removeZone(name)
  local t = getTarget()
  if t then t.removeZone(name) end
end

function retro.bridge.target.disableTargeting(state)
  local t = getTarget()
  if t then t.disableTargeting(state) end
end

function retro.bridge.target.isAvailable()
  local t = getTarget()
  return t and t.isAvailable() or false
end

function retro.bridge.target.getName()
  local t = getTarget()
  return t and t.name or "none"
end

-- ══════════════════════════════════════════
-- INVENTORY
-- ══════════════════════════════════════════

retro.bridge.inventory = {}

local function getInventory()
  return exports['retro-kit']:GetBridgeInventory()
end

function retro.bridge.inventory.isAvailable()
  local inv = getInventory()
  return inv and inv.isAvailable() or false
end

function retro.bridge.inventory.getName()
  local inv = getInventory()
  return inv and inv.name or "none"
end

function retro.bridge.inventory.getItem(source, itemName)
  local inv = getInventory()
  if inv then return inv.getItem(source, itemName) end
  return nil
end

function retro.bridge.inventory.getItems(source)
  local inv = getInventory()
  if inv then return inv.getItems(source) end
  return {}
end

function retro.bridge.inventory.getItemCount(source, itemName)
  local inv = getInventory()
  if inv then return inv.getItemCount(source, itemName) end
  return 0
end

function retro.bridge.inventory.hasItem(source, itemName, amount)
  local inv = getInventory()
  if inv then return inv.hasItem(source, itemName, amount) end
  return false
end

function retro.bridge.inventory.addItem(source, itemName, amount, metadata)
  local inv = getInventory()
  if inv then return inv.addItem(source, itemName, amount, metadata) end
  return false
end

function retro.bridge.inventory.removeItem(source, itemName, amount, metadata)
  local inv = getInventory()
  if inv then return inv.removeItem(source, itemName, amount, metadata) end
  return false
end

function retro.bridge.inventory.canCarry(source, itemName, amount)
  local inv = getInventory()
  if inv then return inv.canCarry(source, itemName, amount) end
  return false
end

function retro.bridge.inventory.setMetadata(source, slot, metadata)
  local inv = getInventory()
  if inv then return inv.setMetadata(source, slot, metadata) end
  return false
end

function retro.bridge.inventory.getSlots(source)
  local inv = getInventory()
  if inv then return inv.getSlots(source) end
  return 0
end

function retro.bridge.inventory.getWeight(source)
  local inv = getInventory()
  if inv then return inv.getWeight(source) end
  return 0, 0
end