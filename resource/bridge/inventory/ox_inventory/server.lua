-- ══════════════════════════════════════════
-- OX_INVENTORY BRIDGE
-- ══════════════════════════════════════════

local ox_inventory = exports.ox_inventory

local Inventory = {}

Inventory.name = "ox_inventory"

function Inventory.isAvailable()
  return true
end

function Inventory.getItem(source, itemName)
  local item = ox_inventory:GetItem(source, itemName, nil, false)
  if not item then return nil end

  return {
    name = item.name,
    label = item.label,
    count = item.count or 0,
    slot = item.slot,
    weight = item.weight,
    metadata = item.metadata,
  }
end

function Inventory.getItems(source)
  local items = ox_inventory:GetInventoryItems(source, false)
  if not items then return {} end

  local result = {}
  for _, item in pairs(items) do
    if item.name then
      result[#result + 1] = {
        name = item.name,
        label = item.label,
        count = item.count or 0,
        slot = item.slot,
        weight = item.weight,
        metadata = item.metadata,
      }
    end
  end

  return result
end

function Inventory.getItemCount(source, itemName)
  local count = ox_inventory:GetItem(source, itemName, nil, true)
  return count or 0
end

function Inventory.hasItem(source, itemName, amount)
  local count = Inventory.getItemCount(source, itemName)
  return count >= (amount or 1)
end

function Inventory.addItem(source, itemName, amount, metadata)
  local success = ox_inventory:AddItem(source, itemName, amount, metadata)
  return success and true or false
end

function Inventory.removeItem(source, itemName, amount, metadata)
  local success = ox_inventory:RemoveItem(source, itemName, amount, metadata)
  return success and true or false
end

function Inventory.canCarry(source, itemName, amount)
  local result = ox_inventory:CanCarryItem(source, itemName, amount)
  return result and true or false
end

function Inventory.setMetadata(source, slot, metadata)
  ox_inventory:SetMetadata(source, slot, metadata)
  return true
end

function Inventory.getSlots(source)
  local inv = ox_inventory:GetInventory(source, false)
  if not inv then return 0 end
  return #inv
end

function Inventory.getWeight(source)
  local inv = ox_inventory:GetInventory(source)
  if not inv then return 0, 0 end

  local currentWeight = 0

  if type(inv) == "table" then
    if inv.weight ~= nil and inv.maxWeight ~= nil then
      return inv.weight, inv.maxWeight
    end

    local items = inv.items or inv
    if type(items) == "table" then
      for _, item in pairs(items) do
        if item and item.weight and item.count then
          currentWeight = currentWeight + (item.weight * item.count)
        end
      end
    end
  end

  local maxWeight = 0
  local success, result = pcall(function()
    return ox_inventory:GetInventory(source, false)
  end)

  if success and type(result) == "table" and result.maxWeight then
    maxWeight = result.maxWeight
  else
    maxWeight = 80000 -- Default ox_inventory
  end

  return currentWeight, maxWeight
end

return Inventory