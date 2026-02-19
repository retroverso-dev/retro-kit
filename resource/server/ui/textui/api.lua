RetroKitServer = RetroKitServer or { config = _G.Config or {}, ui = {} }

RetroKitServer.ui.textUi = function(player, data)
  data = data or {}

  local payload = {
    position = data.position or "right-center",
    content = data.content,
  }

  TriggerClientEvent("retro-kit:textUi", player, payload)
end

RetroKitServer.ui.textUiHide = function(player)
  TriggerClientEvent("retro-kit:textUiHide", player)
end