if not (RetroKitServer and RetroKitServer.config and RetroKitServer.config.debug) then
  return
end

local ui = RetroKitServer.ui

local tests = {}

-- ══════════════════════════════════════════
-- NOTIFICATION
-- ══════════════════════════════════════════
tests["notification"] = function(src, args)
  local style = (args[2] or "info"):lower()

  ui.notify(src, {
    style = style,
    title = "Notificação de Teste",
    description = ("Estilo: %s"):format(style),
    showDuration = true,
    iconAnimation = "bounce",
  })
end

tests["notify"] = tests["notification"]

-- ══════════════════════════════════════════
-- ALERT
-- ══════════════════════════════════════════
tests["alert"] = function(src)
  ui.alert(src, {
    title = "Alert de Teste",
    description = "Este é um alert de teste.",
    cancel = true,
    icon = "Bell",
    iconAnimation = "pulse",
  })
end

-- ══════════════════════════════════════════
-- PROGRESS
-- ══════════════════════════════════════════
tests["progress"] = function(src, args)
  local progressType = (args[2] or "bar"):lower()

  if progressType == "circle" then
    return ui.circleProgress(src, {
      label = "Processing...",
      duration = 5000,
      position = "middle",
      percent = true,
      canCancel = true,
    }, function(cancelled)
      ui.notify(src, {
        style = cancelled and "warning" or "success",
        title = cancelled and "Cancelled" or "Complete",
        description = cancelled and "Circle progress was cancelled." or "Circle progress finished!",
      })
    end)
  end

  ui.progress(src, {
    label = "Loading...",
    duration = 5000,
    position = "bottom",
    percent = true,
    canCancel = true,
  }, function(cancelled)
    ui.notify(src, {
      style = cancelled and "warning" or "success",
      title = cancelled and "Cancelled" or "Complete",
      description = cancelled and "Progress was cancelled." or "Progress finished!",
    })
  end)
end

-- ══════════════════════════════════════════
-- CONTEXT MENU
-- ══════════════════════════════════════════
tests["context"] = function(src)
  -- ── Submenu ──────────────────────
  ui.registerContext(src, "test_submenu", {
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
          { label = "Weight",   value = "0.5kg" },
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
          { label = "Quantity",   value = "1x" },
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
    water = function()
      ui.notify(src, {
        style = "success",
        title = "Item Used",
        description = "You drank a Water Bottle. +25% thirst.",
        icon = "Droplets",
        iconAnimation = "bounce",
        duration = 3000,
      })
    end,
    medkit = function()
      ui.progress(src, {
        label = "Using Medical Kit...",
        duration = 4000,
        position = "bottom",
        percent = true,
        canCancel = true,
      }, function(cancelled)
        ui.notify(src, {
          style = cancelled and "warning" or "success",
          title = cancelled and "Cancelled" or "Healed",
          description = cancelled
            and "You stopped using the Medical Kit."
            or "Medical Kit used. +50% health.",
          icon = cancelled and "Ban" or "HeartPulse",
          iconAnimation = cancelled and nil or "pulse",
          duration = 3000,
        })
      end)
    end,
  })

  -- ── Main menu ────────────────────
  ui.registerContext(src, "test_main", {
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
          XP    = "12,350 / 15,000",
          Rank  = "Gold",
        },
      },
      btn_metadata_progress = {
        title = "Skills",
        description = "Progress metadata example",
        icon = "Trophy",
        iconColor = "text-amber-400",
        readOnly = true,
        metadata = {
          { label = "Driving",  value = "Advanced",     progress = 85, colorScheme = "#22c55e" },
          { label = "Shooting", value = "Intermediate", progress = 55, colorScheme = "#eab308" },
          { label = "Stealth",  value = "Beginner",     progress = 20, colorScheme = "#ef4444" },
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
      ui.notify(src, {
        style = "info",
        title = "Button Clicked",
        description = "You clicked the simple button!",
        icon = "MousePointerClick",
        iconAnimation = "bounce",
        duration = 3000,
      })
    end,
    btn_icon_anim = function()
      ui.notify(src, {
        style = "success",
        title = "Settings",
        description = "Opening settings panel...",
        icon = "Settings",
        iconAnimation = "spin",
        duration = 3000,
      })
    end,
    btn_circle = function()
      ui.circleProgress(src, {
        label = "Scanning area...",
        duration = 5000,
        position = "middle",
        percent = true,
        canCancel = true,
      }, function(cancelled)
        ui.notify(src, {
          style = cancelled and "warning" or "success",
          title = cancelled and "Scan Cancelled" or "Scan Complete",
          description = cancelled
            and "Area scan was interrupted."
            or "Area has been fully scanned!",
          icon = cancelled and "Ban" or "ScanSearch",
          iconAnimation = cancelled and nil or "bounce",
          duration = 3000,
        })
      end)
    end,
    btn_alert = function()
      ui.alert(src, {
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

  ui.showContext(src, "test_main")
end

tests["menu"] = tests["context"]

-- ══════════════════════════════════════════
-- TEXT UI
-- ══════════════════════════════════════════
local textuiVariants = {
  hide = function(src)
    ui.textUiHide(src)
    ui.notify(src, {
      style = "info",
      title = "TextUI",
      description = "TextUI hidden.",
      duration = 2000,
    })
  end,

  multi = function(src)
    ui.textUi(src, {
      position = "right-center",
      content = {
        { uiKey = "E", text = "Open Door" },
        { uiKey = "G", text = "Lock Door" },
        { text = "Hold to interact" },
      },
    })
  end,

  left = function(src)
    ui.textUi(src, {
      position = "left-center",
      content = { uiKey = "F", text = "Pick up item" },
    })
  end,

  top = function(src)
    ui.textUi(src, {
      position = "top-center",
      content = { text = "You are entering a restricted zone" },
    })
  end,

  bottom = function(src)
    ui.textUi(src, {
      position = "bottom-center",
      content = { uiKey = "H", text = "Honk horn" },
    })
  end,

  single = function(src)
    ui.textUi(src, {
      position = "right-center",
      content = { uiKey = "E", text = "Interact" },
    })
  end,
}

tests["textui"] = function(src, args)
  local variant = (args[2] or "single"):lower()
  local handler = textuiVariants[variant] or textuiVariants["single"]
  handler(src)
end

-- ══════════════════════════════════════════
-- COMMAND REGISTRATION
-- ══════════════════════════════════════════
RegisterCommand("test", function(source, args)
  local component = (args[1] or "notification"):lower()
  local handler = tests[component]

  if handler then
    handler(source, args)
  else
    ui.notify(source, {
      style = "error",
      title = "Erro",
      description = ("Componente desconhecido: %s"):format(component),
    })
  end
end, false)

print("^2[Retro Kit]^7 Debug mode enabled! Use /test [alert|notification|progress|context|textui] [type]")