RegisterNetEvent("retro-kit:closeAlert")
AddEventHandler("retro-kit:closeAlert", function(payload)
  if not RetroKitServer.config.debug then return end
  print(("[retro-kit] Alert closed by player %s"):format(source))
end)