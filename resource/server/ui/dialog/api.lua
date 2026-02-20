RetroKitServer = RetroKitServer or { config = _G.Config or {}, ui = {} }

local pendingDialogs = {}

RetroKitServer.ui.dialog = function(player, data)
  data = data or {}

  local payload = {
    heading = data.heading or "Dialog",
    description = data.description,
    rows = data.rows or {},
    options = data.options or {},
  }

  local p = promise.new()
  pendingDialogs[player] = p

  TriggerClientEvent("retro-kit:openDialog", player, payload)

  local result = Citizen.Await(p)
  pendingDialogs[player] = nil

  return result
end

RegisterNetEvent("retro-kit:dialogResult")
AddEventHandler("retro-kit:dialogResult", function(data)
  local src = source
  local p = pendingDialogs[src]
  if p then
    p:resolve(data)
  end
end)