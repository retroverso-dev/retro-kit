-- ══════════════════════════════════════════
-- ESX FRAMEWORK BRIDGE
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

function Framework.getPlayer(source)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return nil end

  local job = xPlayer.getJob()
  local name = xPlayer.getName() or ""
  local parts = {}
  for word in name:gmatch("%S+") do
    parts[#parts + 1] = word
  end

  local accounts = xPlayer.getAccounts()
  local money = { cash = 0, bank = 0 }
  for _, acc in ipairs(accounts) do
    if acc.name == "money" then
      money.cash = acc.money or 0
    elseif acc.name == "bank" then
      money.bank = acc.money or 0
    end
  end

  return {
    source = source,
    identifier = xPlayer.getIdentifier(),
    name = name,
    firstName = parts[1] or "",
    lastName = parts[2] or "",
    job = {
      name = job.name,
      label = job.label,
      grade = job.grade or 0,
      gradeLabel = job.grade_label or "",
      onDuty = nil,
    },
    gang = nil,
    money = money,
    dob = xPlayer.get and xPlayer.get("dateofbirth") or nil,
    gender = xPlayer.get and xPlayer.get("sex") or nil,
    phone = xPlayer.get and xPlayer.get("phone_number") or nil,
  }
end

function Framework.getIdentifier(source)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return nil end
  return xPlayer.getIdentifier()
end

function Framework.getName(source)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return nil end
  return xPlayer.getName()
end

function Framework.getJob(source)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return nil end
  local job = xPlayer.getJob()
  return {
    name = job.name,
    label = job.label,
    grade = job.grade or 0,
    gradeLabel = job.grade_label or "",
    onDuty = nil,
  }
end

function Framework.getGang(source)
  -- ESX doesn't have gangs natively
  return nil
end

function Framework.getMoney(source, moneyType)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return 0 end

  moneyType = moneyType or "cash"

  local accountName = moneyType
  if moneyType == "cash" then accountName = "money" end

  local account = xPlayer.getAccount(accountName)
  return account and account.money or 0
end

function Framework.addMoney(source, moneyType, amount, reason)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return false end

  moneyType = moneyType or "cash"

  if moneyType == "cash" then
    xPlayer.addAccountMoney("money", amount, reason)
  else
    xPlayer.addAccountMoney(moneyType, amount, reason)
  end

  return true
end

function Framework.removeMoney(source, moneyType, amount, reason)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return false end

  moneyType = moneyType or "cash"

  local accountName = moneyType == "cash" and "money" or moneyType
  local account = xPlayer.getAccount(accountName)
  if not account or (account.money or 0) < amount then
    return false
  end

  xPlayer.removeAccountMoney(accountName, amount, reason)
  return true
end

function Framework.hasGroup(source, group, minGrade)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return false end

  minGrade = minGrade or 0
  local job = xPlayer.getJob()

  return job.name == group and (job.grade or 0) >= minGrade
end

function Framework.isAdmin(source)
  local ESX = getESX()
  local xPlayer = ESX.GetPlayerFromId(source)
  if not xPlayer then return false end

  local group = xPlayer.getGroup()
  return group == "admin" or group == "superadmin" or IsPlayerAceAllowed(tostring(source), "command")
end

function Framework.notify(source, message, type)
  TriggerClientEvent("esx:showNotification", source, message)
end

function Framework.getPlayers()
  local ESX = getESX()
  local xPlayers = ESX.GetExtendedPlayers()
  local players = {}
  for _, xPlayer in pairs(xPlayers) do
    players[#players + 1] = xPlayer.source
  end
  return players
end

function Framework.getPlayerCount()
  return #Framework.getPlayers()
end

return Framework