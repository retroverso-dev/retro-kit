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

  if component == "context" or component == "menu" then
    local src = source

    -- Register submenu first
    RetroKitServer.ui.registerContext(src, "test_submenu", {
      title = "Inventory",
      description = "Player inventory details",
      menu = "test_main",
      canClose = true,
      options = {
        water = {
          title = "Water Bottle",
          description = "Restores 25% thirst",
          icon = "Droplets",
          iconColor = "text-blue-400",
          metadata = {
            { label = "Quantity", value = "3x" },
            { label = "Weight", value = "0.5kg" },
          },
        },
        medkit = {
          title = "Medical Kit",
          description = "Restores 50% health",
          icon = "Heart",
          iconColor = "text-red-400",
          iconAnimation = "pulse",
          progress = 50,
          colorScheme = "#ef4444",
          metadata = {
            { label = "Quantity", value = "1x" },
            { label = "Durability", value = 75, progress = 75, colorScheme = "#22c55e" },
          },
        },
        lockpick = {
          title = "Lockpick",
          description = "Used to pick locks",
          icon = "KeyRound",
          iconColor = "text-yellow-400",
          disabled = true,
          metadata = { "Broken — cannot be used" },
        },
      },
    }, {
      water = function(args)
        RetroKitServer.ui.notify(src, {
          style = "success",
          title = "Item Used",
          description = "You drank a Water Bottle. +25% thirst.",
          icon = "Droplets",
          iconAnimation = "bounce",
          duration = 3000,
        })
      end,
      medkit = function(args)
        RetroKitServer.ui.progress(src, {
          label = "Using Medical Kit...",
          duration = 4000,
          position = "bottom",
          percent = true,
          canCancel = true,
        }, function(cancelled)
          if cancelled then
            RetroKitServer.ui.notify(src, {
              style = "warning",
              title = "Cancelled",
              description = "You stopped using the Medical Kit.",
              icon = "Ban",
              duration = 3000,
            })
          else
            RetroKitServer.ui.notify(src, {
              style = "success",
              title = "Healed",
              description = "Medical Kit used. +50% health.",
              icon = "HeartPulse",
              iconAnimation = "pulse",
              duration = 3000,
            })
          end
        end)
      end,
    })

    -- Register main menu
    RetroKitServer.ui.registerContext(src, "test_main", {
      title = "Test Context Menu",
      description = "This is a debug context menu with various button types.",
      canClose = true,
      options = {
        btn_simple = {
          title = "Simple Button",
          description = "Click to receive a notification",
          icon = "MousePointerClick",
        },
        btn_icon_anim = {
          title = "Animated Icon",
          description = "This button has a spinning icon",
          icon = "Settings",
          iconAnimation = "spin",
          iconColor = "text-muted-foreground",
        },
        btn_progress = {
          title = "Stamina",
          description = "Current stamina level",
          icon = "Zap",
          iconColor = "text-yellow-400",
          progress = 72,
          colorScheme = "#eab308",
          readOnly = true,
        },
        btn_metadata_kv = {
          title = "Player Stats",
          description = "Key-value metadata example",
          icon = "BarChart3",
          iconColor = "text-purple-400",
          readOnly = true,
          metadata = {
            Level = "42",
            XP = "12,350 / 15,000",
            Rank = "Gold",
          },
        },
        btn_metadata_progress = {
          title = "Skills",
          description = "Progress metadata example",
          icon = "Trophy",
          iconColor = "text-amber-400",
          readOnly = true,
          metadata = {
            { label = "Driving", value = "Advanced", progress = 85, colorScheme = "#22c55e" },
            { label = "Shooting", value = "Intermediate", progress = 55, colorScheme = "#eab308" },
            { label = "Stealth", value = "Beginner", progress = 20, colorScheme = "#ef4444" },
          },
        },
        btn_submenu = {
          title = "Open Inventory",
          description = "View your items",
          icon = "Backpack",
          menu = "test_submenu",
        },
        btn_disabled = {
          title = "Locked Feature",
          description = "Requires Level 50",
          icon = "Lock",
          iconColor = "text-zinc-500",
          disabled = true,
        },
        btn_circle = {
          title = "Circle Progress Test",
          description = "Starts a circle progress on click",
          icon = "Loader",
          iconColor = "text-cyan-400",
        },
        btn_alert = {
          title = "Open Alert",
          description = "Opens an alert dialog on click",
          icon = "Bell",
          iconAnimation = "shake",
          iconColor = "text-orange-400",
        },
      },
    }, {
      btn_simple = function()
        RetroKitServer.ui.notify(src, {
          style = "info",
          title = "Button Clicked",
          description = "You clicked the simple button!",
          icon = "MousePointerClick",
          iconAnimation = "bounce",
          duration = 3000,
        })
      end,
      btn_icon_anim = function()
        RetroKitServer.ui.notify(src, {
          style = "success",
          title = "Settings",
          description = "Opening settings panel...",
          icon = "Settings",
          iconAnimation = "spin",
          duration = 3000,
        })
      end,
      btn_circle = function()
        RetroKitServer.ui.circleProgress(src, {
          label = "Scanning area...",
          duration = 5000,
          position = "middle",
          percent = true,
          canCancel = true,
        }, function(cancelled)
          if cancelled then
            RetroKitServer.ui.notify(src, {
              style = "warning",
              title = "Scan Cancelled",
              description = "Area scan was interrupted.",
              icon = "Ban",
              duration = 3000,
            })
          else
            RetroKitServer.ui.notify(src, {
              style = "success",
              title = "Scan Complete",
              description = "Area has been fully scanned!",
              icon = "ScanSearch",
              iconAnimation = "bounce",
              duration = 3000,
            })
          end
        end)
      end,
      btn_alert = function()
        RetroKitServer.ui.alert(src, {
          title = "Context Alert",
          description = "This alert was triggered from a context menu button!",
          cancel = true,
          icon = "Bell",
          iconAnimation = "bounce",
          iconColor = "text-orange-400",
          labels = {
            cancel = "Dismiss",
            confirm = "Got it!",
          },
        })
      end,
    })

    -- Show the main menu
    RetroKitServer.ui.showContext(src, "test_main")
    return
  end

  RetroKitServer.ui.notify(source, {
    style = "error",
    title = "Erro",
    description = ("Componente desconhecido: %s"):format(component),
  })
end, false)

print("^2[Retro Kit]^7 Debug mode enabled! Use /test [alert|notification|progress|context] [type]")