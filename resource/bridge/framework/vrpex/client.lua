-- ══════════════════════════════════════════
-- VRPEX FRAMEWORK BRIDGE (client)
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "vrpex"

function Framework.isAvailable()
  return true
end

function Framework.getPlayerData()
  -- vRPex doesn't expose player data on client natively
  -- Most data is accessed via server-side Proxy
  return nil
end

function Framework.getJob()
  return nil
end

function Framework.getGang()
  return nil
end

function Framework.getMoney(moneyType)
  return 0
end

function Framework.hasGroup(group, minGrade)
  return false
end

function Framework.getIdentifier()
  return nil
end

function Framework.getName()
  return nil
end

return Framework