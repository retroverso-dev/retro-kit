RetroKitServer = RetroKitServer or { config = _G.Config or {}, ui = {} }

RetroKitServer.ui.notify = function(player, data)
  data = data or {}
  local cfg = RetroKitServer.config

  local payload = {
    style = data.style or "info",
    title = data.title or "Notification",
    description = data.description or "",
    duration = data.duration or cfg.notification.defaultDuration,
    showDuration = data.showDuration or false,
    icon = data.icon,
    iconAnimation = data.iconAnimation or "none",
    iconColor = data.iconColor,
    position = data.position or cfg.notification.defaultPosition,
  }

  TriggerClientEvent("retro-kit:notify", player, payload)
end