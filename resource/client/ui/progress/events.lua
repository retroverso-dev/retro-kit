local activeProgress = nil

RegisterNetEvent("retro-kit:progress")
AddEventHandler("retro-kit:progress", function(data)
  activeProgress = {
    type = "progress",
    canCancel = data.canCancel or false,
  }
  RetroKitClient.send("progress", data)
end)

RegisterNetEvent("retro-kit:circleProgress")
AddEventHandler("retro-kit:circleProgress", function(data)
  activeProgress = {
    type = "circleProgress",
    canCancel = data.canCancel or false,
  }
  RetroKitClient.send("circleProgress", data)
end)

-- Server tells client to cancel
RegisterNetEvent("retro-kit:progressCancel")
AddEventHandler("retro-kit:progressCancel", function()
  if activeProgress then
    RetroKitClient.send("progressCancel", {})
    activeProgress = nil
    TriggerServerEvent("retro-kit:progressCancelled", {})
  end
end)

-- Player presses a key to cancel (handled by client keybind)
function CancelActiveProgress()
  if activeProgress and activeProgress.canCancel then
    RetroKitClient.send("progressCancel", {})
    activeProgress = nil
    TriggerServerEvent("retro-kit:progressCancelled", {})
  end
end

exports("CancelProgress", CancelActiveProgress)