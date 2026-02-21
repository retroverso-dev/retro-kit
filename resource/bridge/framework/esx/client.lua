-- ══════════════════════════════════════════
-- ESX FRAMEWORK BRIDGE (client)
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "esx"

local ESXObj = nil

local function getESX()
  if not ESXObj then
    ESXObj = exports['es_extended']:getSharedObject()
  end
  return ESXObj
end

function Framework.isAvailable()
  return true
end

function Framework.getPlayerData()
  local ESX = getESX()
  local pd = ESX.GetPlayerData()
  if not pd or not pd.identifier then return nil end

  local name = pd.firstName or ""
  local lastName = pd.lastName or ""

  local money = { cash = 0, bank = 0 }
  if pd.accounts then
    for _, acc in ipairs(pd.accounts) do
      if acc.name == "money" then
        money.cash = acc.money or 0
      elseif acc.name == "bank" then
        money.bank = acc.money or 0
      end
    end
  end

  return {
    source = pd.source,
    identifier = pd.identifier,
    name = ("%s %s"):format(name, lastName),
    firstName = name,
    lastName = lastName,
    job = {
      name = pd.job and pd.job.name or "unemployed",
      label = pd.job and pd.job.label or "Unemployed",
      grade = pd.job and pd.job.grade or 0,
      gradeLabel = pd.job and pd.job.grade_label or "",
      onDuty = nil,
    },
    gang = nil,
    money = money,
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