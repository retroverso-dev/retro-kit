local config = _G.Config or {}

RetroKitClient = RetroKitClient or {
  config = config,
  nuiFocused = false,
}

function RetroKitClient.setFocus(enabled)
  RetroKitClient.nuiFocused = enabled
  SetNuiFocus(enabled, enabled)

  if SetNuiFocusKeepInput then
    SetNuiFocusKeepInput(false)
  end
end

function RetroKitClient.send(action, data)
  SendNUIMessage({
    action = action,
    data = data,
  })
end

RegisterNUICallback("init", function(_, cb)
  TriggerServerEvent("retro-kit:init")
  cb({ ok = true })
end)

RegisterNetEvent("retro-kit:initData")
AddEventHandler("retro-kit:initData", function(data)
  if data.locale then
    RetroKitClient.send("setLocale", data.locale)
  end

  if data.colors then
    RetroKitClient.send("setConfig", data.colors)
  end
end)

AddEventHandler("onResourceStop", function(resourceName)
  if resourceName ~= GetCurrentResourceName() then return end
  if RetroKitClient.nuiFocused then
    RetroKitClient.setFocus(false)
  end
end)

if config.debug then
  print("^2[Retro Kit]^7 Client debug mode enabled")
end