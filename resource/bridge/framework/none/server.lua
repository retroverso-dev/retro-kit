-- ══════════════════════════════════════════
-- NO-OP FRAMEWORK BRIDGE
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "none"

function Framework.isAvailable() return false end
function Framework.getPlayer(source) return nil end
function Framework.getIdentifier(source) return nil end
function Framework.getName(source) return nil end
function Framework.getJob(source) return nil end
function Framework.getGang(source) return nil end
function Framework.getMoney(source, moneyType) return 0 end
function Framework.addMoney(source, moneyType, amount, reason) return false end
function Framework.removeMoney(source, moneyType, amount, reason) return false end
function Framework.hasGroup(source, group, minGrade) return false end
function Framework.isAdmin(source) return false end
function Framework.notify(source, message, type) end
function Framework.getPlayers() return {} end
function Framework.getPlayerCount() return 0 end

return Framework