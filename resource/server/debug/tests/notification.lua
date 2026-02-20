return function(tests, ui)

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

end