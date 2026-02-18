RetroKitServer = RetroKitServer or { config = _G.Config or {}, ui = {} }

RetroKitServer.ui.alert = function(player, data)
  data = data or {}
  local cfg = RetroKitServer.config

  local payload = {
    title = data.title or "Alert",
    description = data.description or "",
    size = data.size or cfg.alert.defaultSize,
    cancel = data.cancel or false,
    labels = data.labels or { cancel = "Cancel", confirm = "OK" },
    icon = data.icon,
    iconAnimation = data.iconAnimation or "none",
    iconColor = data.iconColor,
  }

  TriggerClientEvent("retro-kit:sendAlert", player, payload)
end