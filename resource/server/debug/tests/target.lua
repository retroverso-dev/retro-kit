return function(tests, ui)

  tests["target:box"] = function(src)
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    TriggerClientEvent("retro-kit:debug:target:box", src, coords)
  end

  tests["target:entity"] = function(src)
    TriggerClientEvent("retro-kit:debug:target:entity", src)
  end

  tests["target:model"] = function(src)
    TriggerClientEvent("retro-kit:debug:target:model", src)
  end

  tests["target:globalped"] = function(src)
    TriggerClientEvent("retro-kit:debug:target:globalped", src)
  end

end