return function(tests, ui)

  tests["alert"] = function(src)
    ui.alert(src, {
      title = "Alert de Teste",
      description = "Este é um alert de teste.",
      cancel = true,
      icon = "Bell",
      iconAnimation = "pulse",
    })
  end

end