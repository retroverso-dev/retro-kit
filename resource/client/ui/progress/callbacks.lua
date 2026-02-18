RegisterNUICallback("progressComplete", function(_, cb)
  TriggerServerEvent("retro-kit:progressComplete", {})
  cb({ ok = true })
end)

RegisterNUICallback("progressCancelled", function(data, cb)
  TriggerServerEvent("retro-kit:progressCancelled", data)
  cb({ ok = true })
end)