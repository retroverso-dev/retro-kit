-- ══════════════════════════════════════════
-- QBCORE FRAMEWORK BRIDGE (client)
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

function Framework.getPlayerData()
  local QB = getQB()
  local pd = QB.Functions.GetPlayerData()
  if not pd or not pd.citizenid then return nil end

  return {
    source = pd.source,
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
  }
end

function Framework.getJob()
  local pd = Framework.getPlayerData()
  return pd and pd.job or nil
end

function Framework.getGang()
  local pd = Framework.getPlayerData()
  return pd and pd.gang or nil
end

function Framework.getMoney(moneyType)
  local pd = Framework.getPlayerData()
  if not pd then return 0 end
  moneyType = moneyType or "cash"
  return pd.money[moneyType] or 0
end

function Framework.hasGroup(group, minGrade)
  local pd = Framework.getPlayerData()
  if not pd then return false end
  minGrade = minGrade or 0

  if pd.job.name == group and pd.job.grade >= minGrade then
    return true
  end

  if pd.gang and pd.gang.name == group and pd.gang.grade >= minGrade then
    return true
  end

  return false
end

function Framework.getIdentifier()
  local pd = Framework.getPlayerData()
  return pd and pd.identifier or nil
end

function Framework.getName()
  local pd = Framework.getPlayerData()
  return pd and pd.name or nil
end

return Framework