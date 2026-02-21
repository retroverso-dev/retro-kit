if not (_G.Config or {}).debug then return end

RegisterNetEvent("retro-kit:debug:target:box")
AddEventHandler("retro-kit:debug:target:box", function(coords)
  if not Bridge or not Bridge.target then
    print("^1[retro-kit]^7 Target bridge not loaded")
    return
  end

  Bridge.target.addBoxZone({
    name = "retro_debug_box",
    coords = coords,
    size = vec3(3.0, 3.0, 3.0),
    debug = true,
    options = {
      {
        name = "retro_debug_interact",
        label = "Debug Interaction",
        icon = "fas fa-hand",
        distance = 3.0,
        onSelect = function(data)
          print("^2[retro-kit]^7 Box zone interaction triggered!")
          print(("  Entity: %s | Coords: %s"):format(tostring(data.entity), tostring(data.coords)))
        end,
      },
    },
  })

  print(("^2[retro-kit]^7 Debug box zone created at %s"):format(tostring(coords)))
end)

RegisterNetEvent("retro-kit:debug:target:entity")
AddEventHandler("retro-kit:debug:target:entity", function()
  if not Bridge or not Bridge.target then
    print("^1[retro-kit]^7 Target bridge not loaded")
    return
  end

  local ped = PlayerPedId()
  local vehicle = 0

  -- If inside a vehicle, get it directly
  vehicle = GetVehiclePedIsIn(ped, false)

  if vehicle ~= 0 then
    -- Player is inside — they need to be outside to use target
    -- So we store the netId, exit, then resolve the entity again
    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    if netId == 0 or netId == 65534 then
      print("^1[retro-kit]^7 Vehicle has no valid network ID")
      return
    end

    TaskLeaveVehicle(ped, vehicle, 0)
    print("^3[retro-kit]^7 Exiting vehicle to apply target...")

    CreateThread(function()
      local timeout = 50
      while GetVehiclePedIsIn(ped, false) ~= 0 and timeout > 0 do
        Wait(100)
        timeout = timeout - 1
      end
      Wait(500)

      -- Re-resolve entity from netId (handle may have changed)
      local resolvedVehicle = NetworkGetEntityFromNetworkId(netId)
      if resolvedVehicle == 0 or not DoesEntityExist(resolvedVehicle) then
        print("^1[retro-kit]^7 Could not resolve vehicle after exit")
        return
      end

      Bridge.target.addEntity(resolvedVehicle, {
        {
          name = "retro_debug_entity",
          label = "Debug Entity Target",
          icon = "fas fa-car",
          distance = 3.0,
          onSelect = function(data)
            print("^2[retro-kit]^7 Entity interaction triggered!")
            print(("  Entity: %s"):format(tostring(data.entity)))
          end,
        },
      })

      print(("^2[retro-kit]^7 Target added to vehicle (handle: %d, netId: %d)"):format(resolvedVehicle, netId))
    end)
    return
  end

  -- Not in a vehicle — find the closest one
  local coords = GetEntityCoords(ped)
  vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 10.0, 0, 71)

  if vehicle == 0 or not DoesEntityExist(vehicle) then
    print("^3[retro-kit]^7 No vehicle found nearby. Stand next to a vehicle.")
    return
  end

  local netId = NetworkGetNetworkIdFromEntity(vehicle)
  if netId == 0 or netId == 65534 then
    print(("^1[retro-kit]^7 Vehicle %d has no valid network ID (%d)"):format(vehicle, netId))
    return
  end

  Bridge.target.addEntity(vehicle, {
    {
      name = "retro_debug_entity",
      label = "Debug Entity Target",
      icon = "fas fa-car",
      distance = 3.0,
      onSelect = function(data)
        print("^2[retro-kit]^7 Entity interaction triggered!")
        print(("  Entity: %s"):format(tostring(data.entity)))
      end,
    },
  })

  print(("^2[retro-kit]^7 Target added to vehicle (handle: %d, netId: %d)"):format(vehicle, netId))
end)

RegisterNetEvent("retro-kit:debug:target:model")
AddEventHandler("retro-kit:debug:target:model", function()
  if not Bridge or not Bridge.target then
    print("^1[retro-kit]^7 Target bridge not loaded")
    return
  end

  Bridge.target.addModel("prop_atm_01", {
    {
      name = "retro_debug_model",
      label = "Debug ATM Interaction",
      icon = "fas fa-money-bill",
      distance = 2.0,
      onSelect = function(data)
        print("^2[retro-kit]^7 Model interaction triggered!")
        print(("  Entity: %s"):format(tostring(data.entity)))
      end,
    },
  })

  print("^2[retro-kit]^7 Debug model target added to ATMs (prop_atm_01)")
end)

RegisterNetEvent("retro-kit:debug:target:globalped")
AddEventHandler("retro-kit:debug:target:globalped", function()
  if not Bridge or not Bridge.target then
    print("^1[retro-kit]^7 Target bridge not loaded")
    return
  end

  Bridge.target.addGlobalPed({
    {
      name = "retro_debug_globalped",
      label = "Debug Ped Interaction",
      icon = "fas fa-person",
      distance = 2.0,
      onSelect = function(data)
        print("^2[retro-kit]^7 Global ped interaction triggered!")
        print(("  Entity: %s"):format(tostring(data.entity)))
      end,
    },
  })

  print("^2[retro-kit]^7 Debug global ped target added")
end)