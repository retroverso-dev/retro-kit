RegisterNetEvent("retro-kit:textUi")
AddEventHandler("retro-kit:textUi", function(data)
  RetroKitClient.send("textUi", data)
end)

RegisterNetEvent("retro-kit:textUiHide")
AddEventHandler("retro-kit:textUiHide", function()
  RetroKitClient.send("textUiHide", {})
end)