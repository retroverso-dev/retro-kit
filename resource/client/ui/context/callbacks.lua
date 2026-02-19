RegisterNUICallback("clickContext", function(data, cb)
  RetroKitClient.setFocus(false)
  RetroKitClient.send("hideContext", {})
  TriggerServerEvent("retro-kit:contextClick", data)
  cb({ ok = true })
end)

RegisterNUICallback("openContext", function(data, cb)
  if data.back and data.id then
    TriggerServerEvent("retro-kit:contextBack", data.id)
  elseif data.id then
    TriggerServerEvent("retro-kit:contextOpen", data.id)
  end
  cb({ ok = true })
end)

RegisterNUICallback("closeContext", function(_, cb)
  RetroKitClient.setFocus(false)
  TriggerServerEvent("retro-kit:contextClosed", {})
  cb({ ok = true })
end)