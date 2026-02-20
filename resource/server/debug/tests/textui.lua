return function(tests, ui)

  local variants = {
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
    local handler = variants[variant] or variants["single"]
    handler(src)
  end

end