if not (RetroKitServer and RetroKitServer.config and RetroKitServer.config.debug) then
  return
end

RegisterCommand("test", function(source, args)
  local component = (args[1] or "notification"):lower()
  local testType = (args[2] or "info"):lower()

  if component == "alert" then
    return RetroKitServer.ui.alert(source, {
      title = "Alert de Teste",
      description = "Este é um alert de teste.",
      cancel = true,
      icon = "Bell",
      iconAnimation = "pulse",
    })
  end

  if component == "notification" or component == "notify" then
    return RetroKitServer.ui.notify(source, {
      style = testType,
      title = "Notificação de Teste",
      description = ("Estilo: %s"):format(testType),
      showDuration = true,
      iconAnimation = "bounce",
    })
  end

  if component == "progress" then
    local progressType = (args[2] or "bar"):lower()

    if progressType == "circle" then
      return RetroKitServer.ui.circleProgress(source, {
        label = "Processing...",
        duration = 5000,
        position = "middle",
        percent = true,
        canCancel = true,
      }, function(cancelled)
        if cancelled then
          RetroKitServer.ui.notify(source, {
            style = "warning",
            title = "Cancelled",
            description = "Circle progress was cancelled.",
          })
        else
          RetroKitServer.ui.notify(source, {
            style = "success",
            title = "Complete",
            description = "Circle progress finished!",
          })
        end
      end)
    end

    return RetroKitServer.ui.progress(source, {
      label = "Loading...",
      duration = 5000,
      position = "bottom",
      percent = true,
      canCancel = true,
    }, function(cancelled)
      if cancelled then
        RetroKitServer.ui.notify(source, {
          style = "warning",
          title = "Cancelled",
          description = "Progress was cancelled.",
        })
      else
        RetroKitServer.ui.notify(source, {
          style = "success",
          title = "Complete",
          description = "Progress finished!",
        })
      end
    end)
  end

  RetroKitServer.ui.notify(source, {
    style = "error",
    title = "Erro",
    description = ("Componente desconhecido: %s"):format(component),
  })
end, false)

print("^2[Retro Kit]^7 Debug mode enabled! Use /test [alert|notification|progress] [type]")