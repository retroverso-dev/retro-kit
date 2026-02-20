# Inventory Bridge

Unified API for interacting with inventory systems. Configure once in `config.lua` and use a single API regardless of the underlying inventory resource.

## Configuration

```lua
-- config.lua
Config.Bridge = {
  inventory = "ox_inventory", -- "ox_inventory", "qb-inventory", "esx", "none" or "auto"
}
```

| Value                     | Description                        |
| ------------------------- | ---------------------------------- |
| `"auto"`                  | Auto-detect from running resources |
| `"ox_inventory"` / `"ox"` | Use ox_inventory                   |
| `"qb-inventory"` / `"qb"` | Use qb-inventory                   |
| `"esx"` / `"es_extended"` | Use ESX built-in inventory         |
| `"none"` / `"disabled"`   | Disable inventory bridge           |

## Supported Inventories

| Inventory      | getItem | getItems | hasItem | add/remove | canCarry  | metadata    | weight  |
| -------------- | ------- | -------- | ------- | ---------- | --------- | ----------- | ------- |
| `ox_inventory` | ✅      | ✅       | ✅      | ✅         | ✅        | ✅          | ✅      |
| `qb-inventory` | ✅      | ✅       | ✅      | ✅         | ⚠️ \*     | ✅          | ⚠️ \*\* |
| `esx`          | ✅      | ✅       | ✅      | ✅         | ⚠️ \*\*\* | ⚠️ \*\*\*\* | ⚠️ \*\* |
| `none`         | —       | —        | —       | —          | —         | —           | —       |

\* `qb-inventory` canCarry checks for free slots/stacks, not weight-based.
\*\* Weight is calculated manually from items when native function is unavailable. \*** ESX legacy doesn't have `canCarryItem`, always returns `true`.
\*\*** ESX legacy doesn't support per-slot metadata.

---

## Adding Your Own Inventory Bridge

You can add support for any inventory system by creating a bridge file. Follow these steps:

### 1. Create the Bridge Directory

Create a new folder under `resource/bridge/inventory/` with your inventory name:

```
resource/bridge/inventory/
├── ox_inventory/
│   └── server.lua
├── qb-inventory/
│   └── server.lua
├── none/
│   └── server.lua
└── my-inventory/          ← your new bridge
    └── server.lua
```

### 2. Create `server.lua`

Your bridge must return a table implementing all functions from the `InventoryBridge` interface:

```lua
-- filepath: resource/bridge/inventory/my-inventory/server.lua

local Inventory = {}

-- Required: unique name identifier
Inventory.name = "my-inventory"

-- Required: returns true if the inventory system is available
function Inventory.isAvailable()
  return GetResourceState("my-inventory") == "started"
end

-- Required: get a single item by name
-- Return: InventoryItem table or nil
function Inventory.getItem(source, itemName)
  local item = exports['my-inventory']:GetPlayerItem(source, itemName)
  if not item then return nil end

  -- IMPORTANT: normalize to the standard format
  return {
    name     = item.name,           -- string: item identifier
    label    = item.displayName,    -- string: display label
    count    = item.quantity or 0,  -- number: amount
    slot     = item.slotId,         -- number: slot number
    weight   = item.weight,         -- number: item weight
    metadata = item.extra or {},    -- table:  custom data
  }
end

-- Required: get all items
-- Return: InventoryItem[]
function Inventory.getItems(source)
  local items = exports['my-inventory']:GetAllItems(source)
  if not items then return {} end

  local result = {}
  for _, item in pairs(items) do
    if item.name then
      result[#result + 1] = {
        name     = item.name,
        label    = item.displayName,
        count    = item.quantity or 0,
        slot     = item.slotId,
        weight   = item.weight,
        metadata = item.extra or {},
      }
    end
  end
  return result
end

-- Required: get count of a specific item
-- Return: number
function Inventory.getItemCount(source, itemName)
  return exports['my-inventory']:GetItemCount(source, itemName) or 0
end

-- Required: check if player has item (amount defaults to 1)
-- Return: boolean
function Inventory.hasItem(source, itemName, amount)
  local count = Inventory.getItemCount(source, itemName)
  return count >= (amount or 1)
end

-- Required: add item to player inventory
-- Return: boolean (success)
function Inventory.addItem(source, itemName, amount, metadata)
  return exports['my-inventory']:GiveItem(source, itemName, amount, metadata) or false
end

-- Required: remove item from player inventory
-- Return: boolean (success)
function Inventory.removeItem(source, itemName, amount, metadata)
  return exports['my-inventory']:TakeItem(source, itemName, amount) or false
end

-- Required: check if player can carry the item
-- Return: boolean
function Inventory.canCarry(source, itemName, amount)
  return exports['my-inventory']:CanPlayerCarry(source, itemName, amount) or false
end

-- Required: set metadata on a specific slot
-- Return: boolean (success)
function Inventory.setMetadata(source, slot, metadata)
  exports['my-inventory']:SetSlotMetadata(source, slot, metadata)
  return true
end

-- Required: get total inventory slot count
-- Return: number
function Inventory.getSlots(source)
  return exports['my-inventory']:GetMaxSlots(source) or 50
end

-- Required: get current and max weight
-- Return: number, number (current, max)
function Inventory.getWeight(source)
  local current = exports['my-inventory']:GetCurrentWeight(source) or 0
  local max     = exports['my-inventory']:GetMaxWeight(source) or 100000
  return current, max
end

return Inventory
```

### 3. Register the Alias

Add your inventory name to the alias map in `resource/bridge/init.lua`:

```lua
-- In detectInventory()
local aliases = {
  -- ...existing aliases...
  ["my-inventory"] = "my-inventory",
  ["myinv"]        = "my-inventory",
}
```

### 4. Configure

Set it in your `config.lua`:

```lua
Config.Bridge = {
  inventory = "my-inventory",
}
```

Or use `"auto"` and add auto-detection in `detectInventory()`:

```lua
if configured == "auto" then
  -- ...existing checks...
  elseif isResourceStarted("my-inventory") then
    return "my-inventory"
  -- ...
end
```

### 5. Important Rules

- **Always normalize** item data to the standard `InventoryItem` format
- **Always return the correct type** — `nil` for not found, `{}` for empty lists, `false` for failures
- **The file must `return` the table** — the loader expects it
- **Only `server.lua`** is needed for inventory bridges (inventory operations are server-side)
- **Test all functions** before publishing — especially `addItem`/`removeItem` edge cases
- If a function is not supported by your inventory, return the "none" fallback values (`nil`, `0`, `false`, `{}`)

### 6. Test

Enable debug mode and use the test commands:

```lua
Config.debug = true
```
