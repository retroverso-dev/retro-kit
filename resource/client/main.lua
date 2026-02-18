local config = require("shared.config")

-- NUI Callback para notificações
RegisterNuiCallbackType("notify")
RegisterNuiCallbackType("sendAlert")
RegisterNuiCallbackType("closeAlert")
RegisterNuiCallbackType("init")

-- Receber notificações do servidor
RegisterNetEvent("retro-kit:notify")
AddEventHandler("retro-kit:notify", function(data)
  SendNuiMessage(json.encode({
    type = "notify",
    data = data,
  }))
end)

-- Receber alerts do servidor
RegisterNetEvent("retro-kit:sendAlert")
AddEventHandler("retro-kit:sendAlert", function(data)
  SendNuiMessage(json.encode({
    type = "sendAlert",
    data = data,
  }))
end)

-- Callback NUI
NuiCallbacks = {}

NuiCallbacks.closeAlert = function(data, cb)
  TriggerServerEvent("retro-kit:closeAlert", data)
  cb("ok")
end

NuiCallbacks.init = function(data, cb)
  TriggerServerEvent("retro-kit:init")
  cb("ok")
end

-- Handler geral de callbacks NUI
RegisterNuiCallbackType("callback")
RegisterNuiCallback("callback", function(data, cb)
  if NuiCallbacks[data.method] then
    NuiCallbacks[data.method](data.args, cb)
  else
    print("^1[Retro Kit]^7 Unknown NUI callback: " .. (data.method or "none"))
    cb("error")
  end
end)

-- Funções públicas do cliente
function ClientNotify(title, description, style, options)
  TriggerEvent("retro-kit:notify", {
    style = style or "info",
    title = title,
    description = description,
    duration = options and options.duration or config.notification.defaultDuration,
    showDuration = options and options.showDuration or false,
    icon = options and options.icon,
    iconAnimation = options and options.iconAnimation or "none",
    iconColor = options and options.iconColor,
    position = options and options.position or config.notification.defaultPosition,
  })
end

function ClientAlert(title, description, options)
  TriggerEvent("retro-kit:sendAlert", {
    title = title,
    description = description,
    size = options and options.size or config.alert.defaultSize,
    cancel = options and options.cancel or false,
    labels = options and options.labels or { cancel = "Cancel", confirm = "OK" },
    icon = options and options.icon,
    iconAnimation = options and options.iconAnimation or "none",
    iconColor = options and options.iconColor,
  })
end

-- Exportar funções públicas
exports("ClientNotify", ClientNotify)
exports("ClientAlert", ClientAlert)

if config.debug then
  print("^2[Retro Kit]^7 Client debug mode enabled")
end