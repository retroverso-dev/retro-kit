RegisterNetEvent("retro-kit:init")
AddEventHandler("retro-kit:init", function()
  if RetroKitServer.config.debug then
    print(("Retro Kit initialized for player: %s"):format(source))
  end
end)