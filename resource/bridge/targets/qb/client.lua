local qb_target = exports['qb-target']

-- ══════════════════════════════════════════
-- OPTION MAPPER
-- ══════════════════════════════════════════

local function mapOption(opt)
  return {
    type = "client",
    label = opt.label,
    icon = opt.icon,
    action = function(entity)
      if opt.onSelect then
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local entityCoords = type(entity) == "number" and GetEntityCoords(entity) or playerCoords
        local distance = #(playerCoords - entityCoords)

        opt.onSelect({
          entity = entity,
          coords = entityCoords,
          distance = distance,
          name = opt.name,
        })
      end
    end,
    canInteract = opt.canInteract and function(entity, distance, data)
      local coords = type(entity) == "number" and GetEntityCoords(entity) or GetEntityCoords(PlayerPedId())
      return opt.canInteract(entity, distance, coords, opt.name)
    end or nil,
    job = opt.groups,
    item = opt.items,
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

local function getDistance(options)
  for _, opt in ipairs(options) do
    if opt.distance then return opt.distance end
  end
  return 2.0
end

local function getLabels(options)
  local labels = {}
  for _, opt in ipairs(options) do
    labels[#labels + 1] = opt.label
  end
  return labels
end

local function modelsToHashes(models)
  local hashes = {}
  for _, model in ipairs(models) do
    if type(model) == "string" then
      hashes[#hashes + 1] = GetHashKey(model)
    else
      hashes[#hashes + 1] = model
    end
  end
  return hashes
end

-- ══════════════════════════════════════════
-- BRIDGE
-- ══════════════════════════════════════════

local Target = {}

-- ── Entity ──────────────────────────────

function Target.addEntity(entities, options)
  local mapped = mapOptions(options)
  local dist = getDistance(options)
  for _, entity in ipairs(toArray(entities)) do
    qb_target:AddTargetEntity(entity, {
      options = mapped,
      distance = dist,
    })
  end
end

function Target.removeEntity(entities, optionNames)
  for _, entity in ipairs(toArray(entities)) do
    -- qb-target RemoveTargetEntity expects labels, not names
    if optionNames then
      qb_target:RemoveTargetEntity(entity, optionNames)
    else
      qb_target:RemoveTargetEntity(entity)
    end
  end
end

-- ── Model ───────────────────────────────

function Target.addModel(models, options)
  local mapped = mapOptions(options)
  local dist = getDistance(options)
  local hashes = modelsToHashes(toArray(models))
  qb_target:AddTargetModel(hashes, {
    options = mapped,
    distance = dist,
  })
end

function Target.removeModel(models, optionNames)
  local hashes = modelsToHashes(toArray(models))
  if optionNames then
    qb_target:RemoveTargetModel(hashes, optionNames)
  else
    qb_target:RemoveTargetModel(hashes)
  end
end

-- ── Global Player ───────────────────────

function Target.addGlobalPlayer(options)
  local mapped = mapOptions(options)
  local dist = getDistance(options)
  qb_target:AddGlobalPlayer({
    options = mapped,
    distance = dist,
  })
end

function Target.removeGlobalPlayer(optionNames)
  if optionNames then
    qb_target:RemoveGlobalPlayer(optionNames)
  else
    qb_target:RemoveGlobalPlayer()
  end
end

-- ── Global Ped ──────────────────────────

function Target.addGlobalPed(options)
  local mapped = mapOptions(options)
  local dist = getDistance(options)
  qb_target:AddGlobalPed({
    options = mapped,
    distance = dist,
  })
end

function Target.removeGlobalPed(optionNames)
  if optionNames then
    qb_target:RemoveGlobalPed(optionNames)
  else
    qb_target:RemoveGlobalPed()
  end
end

-- ── Global Vehicle ──────────────────────

function Target.addGlobalVehicle(options)
  local mapped = mapOptions(options)
  local dist = getDistance(options)
  qb_target:AddGlobalVehicle({
    options = mapped,
    distance = dist,
  })
end

function Target.removeGlobalVehicle(optionNames)
  if optionNames then
    qb_target:RemoveGlobalVehicle(optionNames)
  else
    qb_target:RemoveGlobalVehicle()
  end
end

-- ── Global Object ───────────────────────

function Target.addGlobalObject(options)
  local mapped = mapOptions(options)
  local dist = getDistance(options)
  qb_target:AddGlobalObject({
    options = mapped,
    distance = dist,
  })
end

function Target.removeGlobalObject(optionNames)
  if optionNames then
    qb_target:RemoveGlobalObject(optionNames)
  else
    qb_target:RemoveGlobalObject()
  end
end

-- ── Zones ───────────────────────────────

function Target.addBoxZone(params)
  local mapped = mapOptions(params.options)
  local dist = params.distance or getDistance(params.options)
  local size = params.size or vec3(2, 2, 2)
  local heading = params.rotation and params.rotation.z or 0

  qb_target:AddBoxZone(params.name, params.coords, size.x, size.y, {
    name = params.name,
    heading = heading,
    debugPoly = params.debug or false,
    minZ = params.coords.z - (size.z / 2),
    maxZ = params.coords.z + (size.z / 2),
  }, {
    options = mapped,
    distance = dist,
  })
end

function Target.addSphereZone(params)
  -- qb-target doesn't have native sphere zones, use CircleZone
  local mapped = mapOptions(params.options)
  local dist = params.distance or getDistance(params.options)
  local radius = params.size and params.size.x or 2.0

  qb_target:AddCircleZone(params.name, params.coords, radius, {
    name = params.name,
    debugPoly = params.debug or false,
    useZ = true,
  }, {
    options = mapped,
    distance = dist,
  })
end

function Target.removeZone(name)
  qb_target:RemoveZone(name)
end

-- ── Disable ─────────────────────────────

function Target.disableTargeting(state)
  -- qb-target doesn't have a native disable function
  -- Use state bag as workaround for scripts to check
  LocalPlayer.state:set("isTargetDisabled", state and true or false, false)
end

return Target