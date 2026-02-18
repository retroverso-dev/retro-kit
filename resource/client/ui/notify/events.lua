RegisterNetEvent("retro-kit:notify")
AddEventHandler("retro-kit:notify", function(data)
  RetroKitClient.send("notify", data)
end)