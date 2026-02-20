-- ══════════════════════════════════════════
-- NO-OP TARGET BRIDGE
-- When no target system is available
-- ══════════════════════════════════════════

local Target = {}

Target.name = "none"

function Target.isAvailable()
  return false
end

local function noop()
  return false
end

Target.addEntity          = noop
Target.removeEntity       = noop
Target.addModel           = noop
Target.removeModel        = noop
Target.addGlobalPlayer    = noop
Target.removeGlobalPlayer = noop
Target.addGlobalPed       = noop
Target.removeGlobalPed    = noop
Target.addGlobalVehicle   = noop
Target.removeGlobalVehicle = noop
Target.addGlobalObject    = noop
Target.removeGlobalObject = noop
Target.addBoxZone         = noop
Target.addSphereZone      = noop
Target.removeZone         = noop
Target.disableTargeting   = noop

return Target