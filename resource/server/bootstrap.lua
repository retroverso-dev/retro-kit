local config = _G.Config or {}

RetroKitServer = RetroKitServer or {
  config = config,
  ui = {},
}

config.notification = config.notification or {}
config.alert = config.alert or {}

config.notification.defaultDuration = config.notification.defaultDuration or 5000
config.notification.defaultPosition = config.notification.defaultPosition or "top-right"
config.alert.defaultSize = config.alert.defaultSize or "md"
config.debug = config.debug == true

local function mapNotification(title, description, style, options)
  options = options or {}
  return {
    style = style or "info",
    title = title,
    description = description,
    duration = options.duration,
    showDuration = options.showDuration,
    icon = options.icon,
    iconAnimation = options.iconAnimation,
    iconColor = options.iconColor,
    position = options.position,
  }
end

local function mapAlert(title, description, options)
  options = options or {}
  return {
    title = title,
    description = description,
    size = options.size,
    cancel = options.cancel,
    labels = options.labels,
    icon = options.icon,
    iconAnimation = options.iconAnimation,
    iconColor = options.iconColor,
  }
end

function TriggerNotification(player, title, description, style, options)
  return RetroKitServer.ui.notify(player, mapNotification(title, description, style, options))
end

function TriggerAlert(player, title, description, options)
  return RetroKitServer.ui.alert(player, mapAlert(title, description, options))
end

function TriggerUI(player, component, data)
  component = tostring(component or ""):lower()
  local handler = RetroKitServer.ui[component]
  if type(handler) ~= "function" then
    error(("[retro-kit] unknown ui component: %s"):format(component))
  end
  return handler(player, data or {})
end

function TriggerProgress(player, label, duration, options, onComplete)
  options = options or {}
  options.label = label
  options.duration = duration
  return RetroKitServer.ui.progress(player, options, onComplete)
end

function TriggerCircleProgress(player, label, duration, options, onComplete)
  options = options or {}
  options.label = label
  options.duration = duration
  return RetroKitServer.ui.circleProgress(player, options, onComplete)
end

function CancelProgress(player)
  return RetroKitServer.ui.cancelProgress(player)
end

function RegisterContext(player, id, data, clickCallbacks)
  return RetroKitServer.ui.registerContext(player, id, data, clickCallbacks)
end

function ShowContext(player, id)
  return RetroKitServer.ui.showContext(player, id)
end

function HideContext(player)
  return RetroKitServer.ui.hideContext(player)
end

exports("TriggerNotification", TriggerNotification)
exports("TriggerAlert", TriggerAlert)
exports("UI", TriggerUI)
exports("TriggerProgress", TriggerProgress)
exports("TriggerCircleProgress", TriggerCircleProgress)
exports("CancelProgress", CancelProgress)
exports("RegisterContext", RegisterContext)
exports("ShowContext", ShowContext)
exports("HideContext", HideContext)