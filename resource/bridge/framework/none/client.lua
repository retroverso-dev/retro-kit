-- ══════════════════════════════════════════
-- NO-OP FRAMEWORK BRIDGE (client)
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "none"

function Framework.isAvailable() return false end
function Framework.getPlayerData() return nil end
function Framework.getJob() return nil end
function Framework.getGang() return nil end
function Framework.getMoney(moneyType) return 0 end
function Framework.hasGroup(group, minGrade) return false end
function Framework.getIdentifier() return nil end
function Framework.getName() return nil end

return Framework