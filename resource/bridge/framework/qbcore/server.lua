-- ══════════════════════════════════════════
-- QBCORE FRAMEWORK BRIDGE
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "qbcore"

local QBCore = nil

local function getQB()
  if not QBCore then
    QBCore = exports['qb-core']:GetCoreObject()
  end
  return QBCore
end

function Framework.isAvailable()
  return true
end

function Framework.getPlayer(source)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return nil end

  local pd = Player.PlayerData

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
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return nil end
  return Player.PlayerData.citizenid
end

function Framework.getName(source)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return nil end
  local ci = Player.PlayerData.charinfo
  return ("%s %s"):format(ci.firstname or "", ci.lastname or "")
end

function Framework.getJob(source)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return nil end
  local job = Player.PlayerData.job
  return {
    name = job.name,
    label = job.label,
    grade = job.grade.level or 0,
    gradeLabel = job.grade.name or "",
    onDuty = job.onduty,
  }
end

function Framework.getGang(source)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return nil end
  local gang = Player.PlayerData.gang
  if not gang then return nil end
  return {
    name = gang.name,
    label = gang.label,
    grade = gang.grade.level or 0,
    gradeLabel = gang.grade.name or "",
  }
end

function Framework.getMoney(source, moneyType)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return 0 end
  moneyType = moneyType or "cash"
  return Player.PlayerData.money[moneyType] or 0
end

function Framework.addMoney(source, moneyType, amount, reason)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return false end
  return Player.Functions.AddMoney(moneyType, amount, reason) or false
end

function Framework.removeMoney(source, moneyType, amount, reason)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return false end
  return Player.Functions.RemoveMoney(moneyType, amount, reason) or false
end

function Framework.hasGroup(source, group, minGrade)
  local QB = getQB()
  local Player = QB.Functions.GetPlayer(source)
  if not Player then return false end

  minGrade = minGrade or 0

  local job = Player.PlayerData.job
  if job.name == group and (job.grade.level or 0) >= minGrade then
    return true
  end

  local gang = Player.PlayerData.gang
  if gang and gang.name == group and (gang.grade.level or 0) >= minGrade then
    return true
  end

  return false
end

function Framework.isAdmin(source)
  local QB = getQB()
  return QB.Functions.HasPermission(source, "admin") or IsPlayerAceAllowed(tostring(source), "command")
end

function Framework.notify(source, message, type)
  TriggerClientEvent("QBCore:Notify", source, message, type or "primary")
end

function Framework.getPlayers()
  local QB = getQB()
  local players = {}
  for _, playerId in ipairs(QB.Functions.GetPlayers()) do
    players[#players + 1] = playerId
  end
  return players
end

function Framework.getPlayerCount()
  local QB = getQB()
  return #QB.Functions.GetPlayers()
end

return Framework