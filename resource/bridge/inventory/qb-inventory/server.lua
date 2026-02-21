-- ══════════════════════════════════════════
-- QB-INVENTORY BRIDGE
-- ══════════════════════════════════════════

local Inventory = {}

Inventory.name = "qb-inventory"

local function getPlayer(source)
  local QBCore = exports['qb-core']:GetCoreObject()
  return QBCore.Functions.GetPlayer(source)
end

function Inventory.isAvailable()
  return true
end

function Inventory.getItem(source, itemName)
  local Player = getPlayer(source)
  if not Player then return nil end

  local item = Player.Functions.GetItemByName(itemName)
  if not item then return nil end

  return {
    name = item.name,
    label = item.label,
    count = item.amount or 0,
    slot = item.slot,
    weight = item.weight,
    metadata = item.info,
  }
end

function Inventory.getItems(source)
  local Player = getPlayer(source)
  if not Player then return {} end

  local items = Player.PlayerData.items
  if not items then return {} end

  local result = {}
  for _, item in pairs(items) do
    if item.name then
      result[#result + 1] = {
        name = item.name,
        label = item.label,
        count = item.amount or 0,
        slot = item.slot,
        weight = item.weight,
        metadata = item.info,
      }
    end
  end

  return result
end

function Inventory.getItemCount(source, itemName)
  local Player = getPlayer(source)
  if not Player then return 0 end

  local item = Player.Functions.GetItemByName(itemName)
  return item and (item.amount or 0) or 0
end

function Inventory.hasItem(source, itemName, amount)
  local count = Inventory.getItemCount(source, itemName)
  return count >= (amount or 1)
end

function Inventory.addItem(source, itemName, amount, metadata)
  local Player = getPlayer(source)
  if not Player then return false end

  return Player.Functions.AddItem(itemName, amount, nil, metadata) or false
end

function Inventory.removeItem(source, itemName, amount, metadata)
  local Player = getPlayer(source)
  if not Player then return false end

  return Player.Functions.RemoveItem(itemName, amount, nil, metadata) or false
end

function Inventory.canCarry(source, itemName, amount)
  local Player = getPlayer(source)
  if not Player then return false end

  local success, result = pcall(function()
    return exports['qb-inventory']:CanAddItem(source, itemName, amount)
  end)

  if success and result ~= nil then
    return result and true or false
  end

  local items = Player.PlayerData.items
  if not items then return true end

  -- Pegar peso do item via shared items do QBCore
  local QBCore = exports['qb-core']:GetCoreObject()
  local itemInfo = QBCore.Shared.Items[itemName]
  if not itemInfo then return false end

  local itemWeight = itemInfo.weight or 0

  -- Calcular peso atual
  local currentWeight = 0
  for _, item in pairs(items) do
    if item.name then
      local info = QBCore.Shared.Items[item.name]
      local w = info and info.weight or 0
      currentWeight = currentWeight + (w * (item.amount or 1))
    end
  end

  local maxWeight = QBCore.Config and QBCore.Config.MaxWeight or 120000

  -- Verificar se cabe
  local addedWeight = itemWeight * amount
  if (currentWeight + addedWeight) > maxWeight then
    return false
  end

  local hasStack = false
  local usedSlots = 0
  for _, item in pairs(items) do
    if item.name then
      usedSlots = usedSlots + 1
      if item.name == itemName then
        hasStack = true
      end
    end
  end

  if not hasStack then
    local maxSlots = QBCore.Config and QBCore.Config.MaxSlots or 41
    if usedSlots >= maxSlots then
      return false
    end
  end

  return true
end

function Inventory.setMetadata(source, slot, metadata)
  local Player = getPlayer(source)
  if not Player then return false end

  local items = Player.PlayerData.items
  if not items or not items[slot] then return false end

  items[slot].info = metadata
  Player.Functions.SetInventory(items)
  return true
end

function Inventory.getSlots(source)
  return Config and Config.inventorySlots or 41
end

function Inventory.getWeight(source)
  local Player = getPlayer(source)
  if not Player then return 0, 0 end

  local maxWeight = Config and Config.inventoryMaxWeight or 120000
  local currentWeight = 0

  local items = Player.PlayerData.items
  if items then
    for _, item in pairs(items) do
      currentWeight = currentWeight + (item.weight or 0) * (item.amount or 1)
    end
  end

  return currentWeight, maxWeight
end

return Inventory