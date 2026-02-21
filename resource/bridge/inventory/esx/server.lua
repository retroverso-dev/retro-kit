-- ══════════════════════════════════════════
-- ESX INVENTORY BRIDGE
-- ══════════════════════════════════════════

local Inventory = {}

Inventory.name = "esx"

local ESXObj = nil

local function getESX()
  if not ESXObj then
    ESXObj = exports['es_extended']:getSharedObject()
  end
  return ESXObj
end

local function getPlayer(source)
  local ESX = getESX()
  return ESX.GetPlayerFromId(source)
end

local function itemExists(itemName)
  local ESX = getESX()

  if ESX.Items and ESX.Items[itemName] then
    return true
  end

  if ESX.GetItems then
    local items = ESX.GetItems()
    if items then
      for _, item in pairs(items) do
        if item.name == itemName then
          return true
        end
      end
    end
  end

  return false
end

function Inventory.isAvailable()
  return true
end

function Inventory.getItem(source, itemName)
  local xPlayer = getPlayer(source)
  if not xPlayer then return nil end

  local item = xPlayer.getInventoryItem(itemName)
  if not item then return nil end

  return {
    name = item.name,
    label = item.label,
    count = item.count or 0,
    slot = item.slot,
    weight = item.weight,
    metadata = item.metadata or {},
  }
end

function Inventory.getItems(source)
  local xPlayer = getPlayer(source)
  if not xPlayer then return {} end

  local inventory = xPlayer.getInventory()
  if not inventory then return {} end

  local result = {}
  for _, item in pairs(inventory) do
    if item.name and (item.count or 0) > 0 then
      result[#result + 1] = {
        name = item.name,
        label = item.label,
        count = item.count or 0,
        slot = item.slot,
        weight = item.weight,
        metadata = item.metadata or {},
      }
    end
  end

  return result
end

function Inventory.getItemCount(source, itemName)
  local item = Inventory.getItem(source, itemName)
  return item and item.count or 0
end

function Inventory.hasItem(source, itemName, amount)
  local count = Inventory.getItemCount(source, itemName)
  return count >= (amount or 1)
end

function Inventory.addItem(source, itemName, amount, metadata)
  local xPlayer = getPlayer(source)
  if not xPlayer then return false end

  local item = xPlayer.getInventoryItem(itemName)
  if not item then
    if not itemExists(itemName) then
      return false
    end
  end

  xPlayer.addInventoryItem(itemName, amount, metadata)

  local after = xPlayer.getInventoryItem(itemName)
  if not after or (after.count or 0) < amount then
    return false
  end

  return true
end

function Inventory.removeItem(source, itemName, amount, metadata)
  local xPlayer = getPlayer(source)
  if not xPlayer then return false end

  local current = Inventory.getItemCount(source, itemName)
  if current < amount then return false end

  xPlayer.removeInventoryItem(itemName, amount, metadata)
  return true
end

function Inventory.canCarry(source, itemName, amount)
  local xPlayer = getPlayer(source)
  if not xPlayer then return false end

  if xPlayer.canCarryItem then
    return xPlayer.canCarryItem(itemName, amount)
  end

  return true
end

function Inventory.setMetadata(source, slot, metadata)
  local xPlayer = getPlayer(source)
  if not xPlayer then return false end

  if xPlayer.setInventoryItemMetadata then
    xPlayer.setInventoryItemMetadata(slot, metadata)
    return true
  end

  return false
end

function Inventory.getSlots(source)
  local xPlayer = getPlayer(source)
  if not xPlayer then return 0 end

  if xPlayer.getMaxSlots then
    return xPlayer.getMaxSlots()
  end

  return 40
end

function Inventory.getWeight(source)
  local xPlayer = getPlayer(source)
  if not xPlayer then return 0, 0 end

  if xPlayer.getWeight and xPlayer.getMaxWeight then
    return xPlayer.getWeight(), xPlayer.getMaxWeight()
  end

  local currentWeight = 0
  local inventory = xPlayer.getInventory()
  if inventory then
    for _, item in pairs(inventory) do
      currentWeight = currentWeight + ((item.weight or 0) * (item.count or 0))
    end
  end

  local maxWeight = xPlayer.maxWeight or 24000
  return currentWeight, maxWeight
end

return Inventory