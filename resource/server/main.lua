local config = _G.Config

-- Função pública para criar notificações
function TriggerNotification(player, title, description, style, options)
  style = style or "info"
  options = options or {}

  local notificationData = {
    style = style,
    title = title,
    description = description,
    duration = options.duration or config.notification.defaultDuration,
    showDuration = options.showDuration or false,
    icon = options.icon,
    iconAnimation = options.iconAnimation or "none",
    iconColor = options.iconColor,
    position = options.position or config.notification.defaultPosition,
  }

  TriggerClientEvent("retro-kit:notify", player, notificationData)
end

-- Função pública para criar alerts
function TriggerAlert(player, title, description, options)
  options = options or {}

  local alertData = {
    title = title,
    description = description,
    size = options.size or config.alert.defaultSize,
    cancel = options.cancel or false,
    labels = options.labels or { cancel = "Cancel", confirm = "OK" },
    icon = options.icon,
    iconAnimation = options.iconAnimation or "none",
    iconColor = options.iconColor,
  }

  TriggerClientEvent("retro-kit:sendAlert", player, alertData)
end

-- Callback para fechar alert
RegisterServerEvent("retro-kit:closeAlert")
AddEventHandler("retro-kit:closeAlert", function(button)
  local src = source
  print("Alert closed with button: " .. button .. " from player: " .. src)
  -- Aqui você pode adicionar lógica customizada
end)

-- Comando init da NUI
RegisterServerEvent("retro-kit:init")
AddEventHandler("retro-kit:init", function()
  print("Retro Kit initialized for player: " .. source)
end)

-- Debug commands
if config.debug then
  TriggerEvent("chat:addSuggestion", "/test", "Teste componentes do Retro Kit", {
    { name = "component", help = "Componente a testar (alert, notification)" },
    { name = "type", help = "Tipo específico (success, error, info, warning)" },
  })

  RegisterCommand("test", function(source, args, rawCommand)
    local player = source
    local component = args[1]
    local testType = args[2] or "info"

    if component == "alert" then
      TriggerAlert(player, "Alert de Teste", "Este é um alert de teste com tipo: " .. testType, {
        cancel = true,
        icon = "Bell",
        iconAnimation = "pulse",
      })
    elseif component == "notification" then
      TriggerNotification(
        player,
        "Notificação de Teste",
        "Esta é uma notificação de teste com estilo: " .. testType,
        testType,
        {
          showDuration = true,
          iconAnimation = "bounce",
        }
      )
    else
      TriggerNotification(player, "Erro", "Componente desconhecido: " .. (component or "none"), "error")
    end
  end, false)

  print("^2[Retro Kit]^7 Debug mode enabled! Use /test [alert|notification] [type]")
end

-- Exportar funções públicas
exports("TriggerNotification", TriggerNotification)
exports("TriggerAlert", TriggerAlert)