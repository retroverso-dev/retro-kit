-- ══════════════════════════════════════════
-- QBOX FRAMEWORK BRIDGE
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "qbox"

function Framework.isAvailable()
  return true
end

function Framework.getPlayer(source)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return nil end

  local pd = player.PlayerData

  return {
    source = source,
    identifier = pd.citizenid,
    name = ("%s %s"):format(pd.charinfo.firstname or "", pd.charinfo.lastname or ""),
    firstName = pd.charinfo.firstname or "",
    lastName = pd.charinfo.lastname or "",
    job = {
      name = pd.job.name,
      label = pd.job.label,
      grade = pd.job.grade.level or 0,
      gradeLabel = pd.job.grade.name or "",
      onDuty = pd.job.onduty,
    },
    gang = pd.gang and {
      name = pd.gang.name,
      label = pd.gang.label,
      grade = pd.gang.grade.level or 0,
      gradeLabel = pd.gang.grade.name or "",
    } or nil,
    money = {
      cash = pd.money.cash or 0,
      bank = pd.money.bank or 0,
      crypto = pd.money.crypto or 0,
    },
    dob = pd.charinfo.birthdate,
    gender = pd.charinfo.gender,
    phone = pd.charinfo.phone,
  }
end

function Framework.getIdentifier(source)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return nil end
  return player.PlayerData.citizenid
end

function Framework.getName(source)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return nil end
  local ci = player.PlayerData.charinfo
  return ("%s %s"):format(ci.firstname or "", ci.lastname or "")
end

function Framework.getJob(source)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return nil end
  local job = player.PlayerData.job
  return {
    name = job.name,
    label = job.label,
    grade = job.grade.level or 0,
    gradeLabel = job.grade.name or "",
    onDuty = job.onduty,
  }
end

function Framework.getGang(source)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return nil end
  local gang = player.PlayerData.gang
  if not gang then return nil end
  return {
    name = gang.name,
    label = gang.label,
    grade = gang.grade.level or 0,
    gradeLabel = gang.grade.name or "",
  }
end

function Framework.getMoney(source, moneyType)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return 0 end
  moneyType = moneyType or "cash"
  return player.PlayerData.money[moneyType] or 0
end

function Framework.addMoney(source, moneyType, amount, reason)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return false end
  return player.Functions.AddMoney(moneyType, amount, reason) or false
end

function Framework.removeMoney(source, moneyType, amount, reason)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return false end
  return player.Functions.RemoveMoney(moneyType, amount, reason) or false
end

function Framework.hasGroup(source, group, minGrade)
  local player = exports.qbx_core:GetPlayer(source)
  if not player then return false end
  minGrade = minGrade or 0

  local job = player.PlayerData.job
  if job.name == group and (job.grade.level or 0) >= minGrade then
    return true
  end

  local gang = player.PlayerData.gang
  if gang and gang.name == group and (gang.grade.level or 0) >= minGrade then
    return true
  end

  return false
end

function Framework.isAdmin(source)
  return exports.qbx_core:HasPermission(source, "admin") or IsPlayerAceAllowed(tostring(source), "command")
end

function Framework.notify(source, message, type)
  TriggerClientEvent("QBCore:Notify", source, message, type or "primary")
end

function Framework.getPlayers()
  local qbPlayers = exports.qbx_core:GetQBPlayers()
  local players = {}
  for src, _ in pairs(qbPlayers) do
    players[#players + 1] = src
  end
  return players
end

function Framework.getPlayerCount()
  return #Framework.getPlayers()
end

return Framework