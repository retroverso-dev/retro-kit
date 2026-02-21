-- ══════════════════════════════════════════
-- NO-OP INVENTORY BRIDGE
-- When no inventory system is available
-- ══════════════════════════════════════════

local Inventory = {}

Inventory.name = "none"

function Inventory.isAvailable()
  return false
end

function Inventory.getItem(source, itemName)
  return nil
end

function Inventory.getItems(source)
  return {}
end

function Inventory.getItemCount(source, itemName)
  return 0
end

function Inventory.hasItem(source, itemName, amount)
  return false
end

function Inventory.addItem(source, itemName, amount, metadata)
  return false
end

function Inventory.removeItem(source, itemName, amount, metadata)
  return false
end

function Inventory.canCarry(source, itemName, amount)
  return false
end

function Inventory.setMetadata(source, slot, metadata)
  return false
end

function Inventory.getSlots(source)
  return 0
end

function Inventory.getWeight(source)
  return 0, 0
end

return Inventory