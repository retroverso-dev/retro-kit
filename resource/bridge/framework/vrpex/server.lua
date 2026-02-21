-- ══════════════════════════════════════════
-- VRPEX FRAMEWORK BRIDGE
-- ══════════════════════════════════════════

local Framework = {}
  
Framework.name = "vrp"
local frameworkFolder = 'vrp'
local function init()
	load(LoadResourceFile(frameworkFolder, 'lib/utils.lua'))()
	local Proxy = module(frameworkFolder, "lib/Proxy")
	return Proxy.getInterface("vRP")
end

local vRP = init()

local function getUserId(source)
  if vRP and vRP.getUserId then
    return vRP.getUserId(source)
  end
  return nil
end

function Framework.isAvailable()
  return vRP ~= nil
end

function Framework.getPlayer(source)
  local userId = getUserId(source)
  if not userId then return nil end

  local identity = vRP.getUserIdentity and vRP.getUserIdentity(userId) or {}
  local groups = vRP.getUserGroups and vRP.getUserGroups(userId) or {}

  -- Determine primary job from groups
  local jobName = "unemployed"
  local jobLabel = "Unemployed"
  local jobGrade = 0
  for group, _ in pairs(groups) do
    jobName = group
    jobLabel = group
    break
  end

  local money = {
    cash = vRP.getMoney and vRP.getMoney(userId) or 0,
    bank = vRP.getBankMoney and vRP.getBankMoney(userId) or 0,
  }

  return {
    source = source,
    identifier = tostring(userId),
    name = ("%s %s"):format(identity.name or "", identity.firstname or ""),
    firstName = identity.firstname or identity.name or "",
    lastName = identity.name or "",
    job = {
      name = jobName,
      label = jobLabel,
      grade = jobGrade,
      gradeLabel = "",
      onDuty = nil,
    },
    gang = nil,
    money = money,
    dob = identity.age and tostring(identity.age) or nil,
    gender = nil,
    phone = identity.phone or nil,
  }
end

function Framework.getIdentifier(source)
  local userId = getUserId(source)
  return userId and tostring(userId) or nil
end

function Framework.getName(source)
  local userId = getUserId(source)
  if not userId then return nil end
  local identity = vRP.getUserIdentity and vRP.getUserIdentity(userId) or {}
  return ("%s %s"):format(identity.firstname or "", identity.name or "")
end

function Framework.getJob(source)
  local userId = getUserId(source)
  if not userId then return nil end

  local groups = vRP.getUserGroups and vRP.getUserGroups(userId) or {}
  for group, _ in pairs(groups) do
    return {
      name = group,
      label = group,
      grade = 0,
      gradeLabel = "",
      onDuty = nil,
    }
  end

  return {
    name = "unemployed",
    label = "Unemployed",
    grade = 0,
    gradeLabel = "",
    onDuty = nil,
  }
end

function Framework.getGang(source)
  return nil
end

function Framework.getMoney(source, moneyType)
  local userId = getUserId(source)
  if not userId then return 0 end

  moneyType = moneyType or "cash"

  if moneyType == "cash" then
    return vRP.getMoney and vRP.getMoney(userId) or 0
  elseif moneyType == "bank" then
    return vRP.getBankMoney and vRP.getBankMoney(userId) or 0
  end

  return 0
end

function Framework.addMoney(source, moneyType, amount, reason)
  local userId = getUserId(source)
  if not userId then return false end

  moneyType = moneyType or "cash"

  if moneyType == "cash" then
    if vRP.giveMoney then
      vRP.giveMoney(userId, amount)
      return true
    end
  elseif moneyType == "bank" then
    if vRP.giveBankMoney then
      vRP.giveBankMoney(userId, amount)
      return true
    end
  end

  return false
end

function Framework.removeMoney(source, moneyType, amount, reason)
  local userId = getUserId(source)
  if not userId then return false end

  moneyType = moneyType or "cash"

  if moneyType == "cash" then
    local current = vRP.getMoney and vRP.getMoney(userId) or 0
    if current < amount then return false end
    if vRP.tryPayment then
      return vRP.tryPayment(userId, amount)
    end
  elseif moneyType == "bank" then
    local current = vRP.getBankMoney and vRP.getBankMoney(userId) or 0
    if current < amount then return false end
    if vRP.tryBankPayment then
      return vRP.tryBankPayment(userId, amount)
    end
  end

  return false
end

function Framework.hasGroup(source, group, minGrade)
  local userId = getUserId(source)
  if not userId then return false end

  if vRP.hasGroup then
    return vRP.hasGroup(userId, group) or false
  end

  local groups = vRP.getUserGroups and vRP.getUserGroups(userId) or {}
  return groups[group] ~= nil
end

function Framework.isAdmin(source)
  local userId = getUserId(source)
  if not userId then return false end

  if vRP.hasPermission then
    return vRP.hasPermission(userId, "admin.permall") or IsPlayerAceAllowed(tostring(source), "command")
  end

  return Framework.hasGroup(source, "admin") or IsPlayerAceAllowed(tostring(source), "command")
end

function Framework.notify(source, message, type)
  if vRP.userNotify then
    local userId = getUserId(source)
    if userId then
      vRP.userNotify(userId, message)
    end
  else
    TriggerClientEvent("chat:addMessage", source, { args = { "[Server]", message } })
  end
end

function Framework.getPlayers()
  local players = {}
  for _, playerId in ipairs(GetPlayers()) do
    players[#players + 1] = tonumber(playerId)
  end
  return players
end

function Framework.getPlayerCount()
  return #GetPlayers()
end

return Framework