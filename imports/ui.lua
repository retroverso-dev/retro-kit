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

-- dynamic fallback to support any component without needing to define explicit functions for each one:
-- retro.bank(...), retro.inventory(...), retro.whatever(...)
setmetatable(retro, {
  __index = function(_, key)
    return function(player, data)
      return retro.ui(player, key, data)
    end
  end
})