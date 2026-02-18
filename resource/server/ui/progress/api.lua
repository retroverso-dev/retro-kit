RetroKitServer = RetroKitServer or { config = _G.Config or {}, ui = {} }

-- Store active progress callbacks per player
local activeProgress = {}

--- Start a linear progressbar for a player
---@param player number Player server ID
---@param data { label?: string, duration: number, position?: string, percent?: boolean, canCancel?: boolean }
---@param onComplete? fun(cancelled: boolean) Called when progress finishes or is cancelled
RetroKitServer.ui.progress = function(player, data, onComplete)
  data = data or {}

  -- Store callback
  activeProgress[player] = {
    type = "progress",
    onComplete = onComplete,
    canCancel = data.canCancel or false,
  }

  local payload = {
    label = data.label or "",
    duration = data.duration or 5000,
    position = data.position or "middle",
    percent = data.percent or false,
    canCancel = data.canCancel or false,
  }

  TriggerClientEvent("retro-kit:progress", player, payload)
end

--- Start a circle progressbar for a player
---@param player number Player server ID
---@param data { label?: string, duration: number, position?: string, percent?: boolean, canCancel?: boolean }
---@param onComplete? fun(cancelled: boolean) Called when progress finishes or is cancelled
RetroKitServer.ui.circleProgress = function(player, data, onComplete)
  data = data or {}

  -- Store callback
  activeProgress[player] = {
    type = "circleProgress",
    onComplete = onComplete,
    canCancel = data.canCancel or false,
  }

  local payload = {
    label = data.label or "",
    duration = data.duration or 5000,
    position = data.position or "middle",
    percent = data.percent or false,
    canCancel = data.canCancel or false,
  }

  TriggerClientEvent("retro-kit:circleProgress", player, payload)
end

--- Cancel the active progress for a player (server-side cancel)
---@param player number Player server ID
RetroKitServer.ui.cancelProgress = function(player)
  TriggerClientEvent("retro-kit:progressCancel", player)
  -- The callback will be fired by the progressCancelled event
end

-- Internal: resolve progress callback
local function resolveProgress(player, cancelled)
  local entry = activeProgress[player]
  if not entry then return end

  activeProgress[player] = nil

  if type(entry.onComplete) == "function" then
    entry.onComplete(cancelled)
  end
end

-- Expose for internal use
RetroKitServer._resolveProgress = resolveProgress