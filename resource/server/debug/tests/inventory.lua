return function(tests, ui)

  -- ══════════════════════════════════════════
  -- LOGGING UTILS
  -- ══════════════════════════════════════════

  local function logResult(src, action, data)
    print(("^2[retro-kit]^7 [inventory:%s] %s"):format(action, data))
    ui.notify(src, {
      style = "info",
      title = "Inventory Debug",
      description = ("[%s] %s"):format(action, data),
    })
  end

  local function logError(src, action, data)
    print(("^1[retro-kit]^7 [inventory:%s] %s"):format(action, data))
    ui.notify(src, {
      style = "error",
      title = "Inventory Debug",
      description = ("[%s] %s"):format(action, data),
    })
  end

  local function getInventory()
    return exports['retro-kit']:GetBridgeInventory()
  end

  -- ══════════════════════════════════════════
  -- /retro inventory
  -- Shows which inventory system is active
  -- ══════════════════════════════════════════

  tests["inventory"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "status", "No inventory system available")
      return
    end

    logResult(src, "status", ("Active: %s | Available: %s"):format(inv.name, tostring(inv.isAvailable())))
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:has <item> [amount]
  -- Check if player has item
  -- ══════════════════════════════════════════

  tests["inventory:has"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "has", "No inventory system available")
      return
    end

    local itemName = args[2]
    if not itemName then
      logError(src, "has", "Usage: /retro inventory:has <item> [amount]")
      return
    end

    local amount = tonumber(args[3]) or 1
    local has = inv.hasItem(src, itemName, amount)

    logResult(src, "has", ("hasItem('%s', %d) = %s"):format(itemName, amount, tostring(has)))
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:count <item>
  -- Get item count
  -- ══════════════════════════════════════════

  tests["inventory:count"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "count", "No inventory system available")
      return
    end

    local itemName = args[2]
    if not itemName then
      logError(src, "count", "Usage: /retro inventory:count <item>")
      return
    end

    local count = inv.getItemCount(src, itemName)

    logResult(src, "count", ("getItemCount('%s') = %d"):format(itemName, count))
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:add <item> [amount]
  -- Add item to player
  -- ══════════════════════════════════════════

  tests["inventory:add"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "add", "No inventory system available")
      return
    end

    local itemName = args[2]
    if not itemName then
      logError(src, "add", "Usage: /retro inventory:add <item> [amount]")
      return
    end

    local amount = tonumber(args[3]) or 1
    local success = inv.addItem(src, itemName, amount)

    if success then
      logResult(src, "add", ("addItem('%s', %d) = SUCCESS"):format(itemName, amount))
    else
      logError(src, "add", ("addItem('%s', %d) = FAILED"):format(itemName, amount))
    end
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:remove <item> [amount]
  -- Remove item from player
  -- ══════════════════════════════════════════

  tests["inventory:remove"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "remove", "No inventory system available")
      return
    end

    local itemName = args[2]
    if not itemName then
      logError(src, "remove", "Usage: /retro inventory:remove <item> [amount]")
      return
    end

    local amount = tonumber(args[3]) or 1
    local success = inv.removeItem(src, itemName, amount)

    if success then
      logResult(src, "remove", ("removeItem('%s', %d) = SUCCESS"):format(itemName, amount))
    else
      logError(src, "remove", ("removeItem('%s', %d) = FAILED"):format(itemName, amount))
    end
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:get <item>
  -- Get full item info
  -- ══════════════════════════════════════════

  tests["inventory:get"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "get", "No inventory system available")
      return
    end

    local itemName = args[2]
    if not itemName then
      logError(src, "get", "Usage: /retro inventory:get <item>")
      return
    end

    local item = inv.getItem(src, itemName)

    if item then
      logResult(src, "get", ("name=%s | label=%s | count=%d | slot=%s | weight=%s"):format(
        item.name,
        item.label or "?",
        item.count or 0,
        tostring(item.slot or "?"),
        tostring(item.weight or "?")
      ))

      if item.metadata and next(item.metadata) then
        print(("^2[retro-kit]^7 [inventory:get] Metadata: %s"):format(json.encode(item.metadata)))
      end
    else
      logError(src, "get", ("Item '%s' not found in inventory"):format(itemName))
    end
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:items
  -- List all items in player inventory
  -- ══════════════════════════════════════════

  tests["inventory:items"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "items", "No inventory system available")
      return
    end

    local items = inv.getItems(src)

    if #items == 0 then
      logResult(src, "items", "Inventory is empty")
      return
    end

    print(("^2[retro-kit]^7 [inventory:items] %d items found:"):format(#items))
    for _, item in ipairs(items) do
      print(("  - %s (%s) x%d | slot: %s"):format(
        item.name,
        item.label or "?",
        item.count or 0,
        tostring(item.slot or "?")
      ))
    end

    logResult(src, "items", ("%d items in inventory"):format(#items))
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:carry <item> [amount]
  -- Check if player can carry item
  -- ══════════════════════════════════════════

  tests["inventory:carry"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "carry", "No inventory system available")
      return
    end

    local itemName = args[2]
    if not itemName then
      logError(src, "carry", "Usage: /retro inventory:carry <item> [amount]")
      return
    end

    local amount = tonumber(args[3]) or 1
    local canCarry = inv.canCarry(src, itemName, amount)

    logResult(src, "carry", ("canCarry('%s', %d) = %s"):format(itemName, amount, tostring(canCarry)))
  end

  -- ══════════════════════════════════════════
  -- /retro inventory:weight
  -- Get current and max weight
  -- ══════════════════════════════════════════

  tests["inventory:weight"] = function(src, args)
    local inv = getInventory()
    if not inv or not inv.isAvailable() then
      logError(src, "weight", "No inventory system available")
      return
    end

    local current, max = inv.getWeight(src)
    local slots = inv.getSlots(src)

    logResult(src, "weight", ("Weight: %d / %d | Slots: %d"):format(current, max, slots))
  end

end