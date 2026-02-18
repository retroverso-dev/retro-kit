RegisterNetEvent("retro-kit:progressComplete")
AddEventHandler("retro-kit:progressComplete", function(data)
  local player = source
  if RetroKitServer.config.debug then
    print(("[retro-kit] Progress completed by player %s"):format(player))
  end
  RetroKitServer._resolveProgress(player, false)
end)

RegisterNetEvent("retro-kit:progressCancelled")
AddEventHandler("retro-kit:progressCancelled", function(data)
  local player = source
  if RetroKitServer.config.debug then
    print(("[retro-kit] Progress cancelled by player %s"):format(player))
  end
  RetroKitServer._resolveProgress(player, true)
end)