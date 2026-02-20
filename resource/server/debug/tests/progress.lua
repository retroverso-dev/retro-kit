return function(tests, ui)

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

end