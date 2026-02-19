RetroKitServer = RetroKitServer or { config = _G.Config or {}, ui = {} }

local menus = {}
local menuStack = {}
local callbacks = {}

RetroKitServer.ui.registerContext = function(player, id, data, clickCallbacks)
  if not menus[player] then
    menus[player] = {}
  end
  menus[player][id] = data

  if clickCallbacks then
    if not callbacks[player] then
      callbacks[player] = {}
    end
    callbacks[player][id] = clickCallbacks
  end
end

RetroKitServer.ui.showContext = function(player, id)
  if not menus[player] or not menus[player][id] then
    if RetroKitServer.config.debug then
      print(("[retro-kit] Context menu '%s' not found for player %s"):format(id, player))
    end
    return
  end

  if not menuStack[player] then
    menuStack[player] = {}
  end

  table.insert(menuStack[player], id)

  TriggerClientEvent("retro-kit:showContext", player, menus[player][id])
end

RetroKitServer.ui.hideContext = function(player)
  TriggerClientEvent("retro-kit:hideContext", player)
  if menuStack[player] then
    menuStack[player] = {}
  end
end

local function cleanupPlayer(player)
  menus[player] = nil
  menuStack[player] = nil
  callbacks[player] = nil
end

AddEventHandler("playerDropped", function()
  cleanupPlayer(source)
end)

RegisterNetEvent("retro-kit:contextClick")
AddEventHandler("retro-kit:contextClick", function(data)
  local player = source
  local optionId = data.id

  if RetroKitServer.config.debug then
    print(("[retro-kit] Context click by player %s: option '%s'"):format(player, tostring(optionId)))
  end

  local stack = menuStack[player]
  if not stack or #stack == 0 then return end

  local currentMenuId = stack[#stack]
  local menuData = menus[player] and menus[player][currentMenuId]

  if not menuData then return end

  local option = nil
  if menuData.options then
    if menuData.options[optionId] then
      option = menuData.options[optionId]
    else
      local numId = tonumber(optionId)
      if numId and menuData.options[numId] then
        option = menuData.options[numId]
      end
    end
  end

  if callbacks[player] and callbacks[player][currentMenuId] then
    local cb = callbacks[player][currentMenuId][optionId]
    if type(cb) == "function" then
      cb(option and option.args or nil)
    end
  end

  if option then
    if option.event then
      TriggerClientEvent(option.event, player, option.args)
    end
    if option.serverEvent then
      TriggerClientEvent("retro-kit:contextServerEvent", player, option.serverEvent, option.args)
    end
  end

  if menuStack[player] then
    menuStack[player] = {}
  end
end)

RegisterNetEvent("retro-kit:contextOpen")
AddEventHandler("retro-kit:contextOpen", function(menuId)
  local player = source

  if RetroKitServer.config.debug then
    print(("[retro-kit] Context submenu open by player %s: '%s'"):format(player, tostring(menuId)))
  end

  RetroKitServer.ui.showContext(player, menuId)
end)

RegisterNetEvent("retro-kit:contextBack")
AddEventHandler("retro-kit:contextBack", function(menuId)
  local player = source
  local stack = menuStack[player]

  if not stack or #stack <= 1 then
    RetroKitServer.ui.hideContext(player)
    return
  end

  table.remove(stack)
  local previousMenuId = stack[#stack]
  table.remove(stack)

  if RetroKitServer.config.debug then
    print(("[retro-kit] Context back by player %s: going to '%s'"):format(player, previousMenuId))
  end

  RetroKitServer.ui.showContext(player, previousMenuId)
end)

RegisterNetEvent("retro-kit:contextClosed")
AddEventHandler("retro-kit:contextClosed", function()
  local player = source
  if menuStack[player] then
    menuStack[player] = {}
  end
end)