-- ══════════════════════════════════════════
-- CREATIVE FRAMEWORK BRIDGE (client)
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "creative"

function Framework.isAvailable()
  return true
end

function Framework.getPlayerData()
  local success, player = pcall(function()
    return exports['creative_core']:GetPlayerData()
  end)

  if not success or not player then return nil end

  local charInfo = player.charinfo or player.CharInfo or {}
  local jobData = player.job or player.Job or {}
  local moneyData = player.money or player.Money or {}

  return {
    source = player.source,
    identifier = player.identifier or player.citizenid,
    name = ("%s %s"):format(charInfo.firstname or charInfo.first_name or "", charInfo.lastname or charInfo.last_name or ""),
    firstName = charInfo.firstname or charInfo.first_name or "",
    lastName = charInfo.lastname or charInfo.last_name or "",
    job = {
      name = jobData.name or "unemployed",
      label = jobData.label or "Unemployed",
      grade = jobData.grade or jobData.level or 0,
      gradeLabel = jobData.gradeLabel or jobData.grade_label or "",
      onDuty = jobData.onduty or jobData.onDuty,
    },
    gang = nil,
    money = {
      cash = moneyData.cash or moneyData.money or 0,
      bank = moneyData.bank or 0,
    },
  }
end

function Framework.getJob()
  local pd = Framework.getPlayerData()
  return pd and pd.job or nil
end

function Framework.getGang()
  return nil
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
  return pd.job.name == group and pd.job.grade >= minGrade
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