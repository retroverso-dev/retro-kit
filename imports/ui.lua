retro = retro or {}

---@param player number
---@param component string
---@param data table|nil
function retro.ui(player, component, data)
  return exports['retro-kit']:UI(player, component, data or {})
end

-- explicit aliases
function retro.notify(player, data)
  return retro.ui(player, 'notify', data)
end

function retro.alert(player, data)
  return retro.ui(player, 'alert', data)
end

function retro.progress(player, data, onComplete)
  return exports['retro-kit']:TriggerProgress(player, data.label, data.duration, data, onComplete)
end

function retro.circleProgress(player, data, onComplete)
  return exports['retro-kit']:TriggerCircleProgress(player, data.label, data.duration, data, onComplete)
end

function retro.cancelProgress(player)
  return exports['retro-kit']:CancelProgress(player)
end

function retro.registerContext(player, id, data, clickCallbacks)
  return exports['retro-kit']:RegisterContext(player, id, data, clickCallbacks)
end

function retro.showContext(player, id)
  return exports['retro-kit']:ShowContext(player, id)
end

function retro.hideContext(player)
  return exports['retro-kit']:HideContext(player)
end

function retro.textUi(player, data)
  return exports['retro-kit']:TriggerTextUi(player, data)
end

function retro.textUiHide(player)
  return exports['retro-kit']:HideTextUi(player)
end

function retro.dialog(player, data)
  return exports['retro-kit']:TriggerDialog(player, data)
end

-- dynamic fallback to support any component without needing to define explicit functions for each one:
-- retro.bank(...), retro.inventory(...), retro.whatever(...)
setmetatable(retro, {
  __index = function(_, key)
    return function(player, data)
      return retro.ui(player, key, data)
    end
  end
})