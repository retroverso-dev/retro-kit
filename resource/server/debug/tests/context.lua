return function(tests, ui)

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

end