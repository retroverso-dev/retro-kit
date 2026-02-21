local ox_target = exports.ox_target

-- ══════════════════════════════════════════
-- OPTION MAPPER
-- ══════════════════════════════════════════

local function mapOption(opt)
  return {
    name = opt.name,
    label = opt.label,
    icon = opt.icon,
    distance = opt.distance or 2.0,
    canInteract = opt.canInteract,
    items = opt.items,
    groups = opt.groups,
    onSelect = function(data)
      if opt.onSelect then
        opt.onSelect({
          entity = data.entity,
          coords = data.coords,
          distance = data.distance,
          name = opt.name,
        })
      end
    end,
  }
end

local function mapOptions(options)
  local mapped = {}
  for i = 1, #options do
    mapped[i] = mapOption(options[i])
  end
  return mapped
end

local function toArray(value)
  if type(value) == "table" then return value end
  return { value }
end

local function entityToNetId(entity)
  if NetworkGetEntityIsNetworked(entity) then
    return NetworkGetNetworkIdFromEntity(entity)
  end
  return entity
end

-- ══════════════════════════════════════════
-- BRIDGE
-- ══════════════════════════════════════════

local Target = {}

Target.name = "ox_target"

function Target.isAvailable()
  return true
end

-- ── Entity ──────────────────────────────

function Target.addEntity(entities, options)
  local mapped = mapOptions(options)
  for _, entity in ipairs(toArray(entities)) do
    local netId = entityToNetId(entity)
    ox_target:addEntity(netId, mapped)
  end
end

function Target.removeEntity(entities, optionNames)
  for _, entity in ipairs(toArray(entities)) do
    local netId = entityToNetId(entity)
    if optionNames then
      ox_target:removeEntity(netId, optionNames)
    else
      ox_target:removeEntity(netId)
    end
  end
end

-- ── Model ───────────────────────────────

function Target.addModel(models, options)
  ox_target:addModel(toArray(models), mapOptions(options))
end

function Target.removeModel(models, optionNames)
  if optionNames then
    ox_target:removeModel(toArray(models), optionNames)
  else
    ox_target:removeModel(toArray(models))
  end
end

-- ── Global Player ───────────────────────

function Target.addGlobalPlayer(options)
  ox_target:addGlobalPlayer(mapOptions(options))
end

function Target.removeGlobalPlayer(optionNames)
  if optionNames then
    ox_target:removeGlobalPlayer(optionNames)
  else
    ox_target:removeGlobalPlayer()
  end
end

-- ── Global Ped ──────────────────────────

function Target.addGlobalPed(options)
  ox_target:addGlobalPed(mapOptions(options))
end

function Target.removeGlobalPed(optionNames)
  if optionNames then
    ox_target:removeGlobalPed(optionNames)
  else
    ox_target:removeGlobalPed()
  end
end

-- ── Global Vehicle ──────────────────────

function Target.addGlobalVehicle(options)
  ox_target:addGlobalVehicle(mapOptions(options))
end

function Target.removeGlobalVehicle(optionNames)
  if optionNames then
    ox_target:removeGlobalVehicle(optionNames)
  else
    ox_target:removeGlobalVehicle()
  end
end

-- ── Global Object ───────────────────────

function Target.addGlobalObject(options)
  ox_target:addGlobalObject(mapOptions(options))
end

function Target.removeGlobalObject(optionNames)
  if optionNames then
    ox_target:removeGlobalObject(optionNames)
  else
    ox_target:removeGlobalObject()
  end
end

-- ── Zones ───────────────────────────────

function Target.addBoxZone(params)
  ox_target:addBoxZone({
    name = params.name,
    coords = params.coords,
    size = params.size or vec3(2, 2, 2),
    rotation = params.rotation and params.rotation.z or 0,
    debug = params.debug or false,
    options = mapOptions(params.options),
  })
end

function Target.addSphereZone(params)
  ox_target:addSphereZone({
    name = params.name,
    coords = params.coords,
    radius = params.size and params.size.x or 2.0,
    debug = params.debug or false,
    options = mapOptions(params.options),
  })
end

function Target.removeZone(name)
  ox_target:removeZone(name)
end

-- ── Disable ─────────────────────────────

function Target.disableTargeting(state)
  ox_target:disableTargeting(state)
end

return Target