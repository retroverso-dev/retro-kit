-- ══════════════════════════════════════════
-- VRPEX FRAMEWORK BRIDGE
-- ══════════════════════════════════════════

local Framework = {}
  
Framework.name = "vrp"
local function init()
	load(LoadResourceFile(Framework.name, 'lib/utils.lua'))()
	local Proxy = module(Framework.name, "lib/Proxy")
	return Proxy.getInterface("vRP")
end

local vRP = init()

local function to_number_safe(v)
  local t = type(v)
  if t == "number" then return v end
  if t == "string" then return tonumber(v) or 0 end
  if t == "table" then
    -- tenta chaves comuns
    if v.amount and tonumber(v.amount) then return tonumber(v.amount) end
    if v.qtd and tonumber(v.qtd) then return tonumber(v.qtd) end
    if v.quantity and tonumber(v.quantity) then return tonumber(v.quantity) end
    if v[1] ~= nil then -- lista dentro da tabela
      return to_number_safe(v[1])
    end
    local s = 0
    for _,val in pairs(v) do
      s = s + to_number_safe(val)
    end
    return s
  end
  return 0
end

local function getTotalCashMoney(source)
  local userId = vRP.getUserId(source)
  if not userId then return 0 end

  local cashItems = vRP.getInventoryItemAmount(userId, "dollars")
  if type(cashItems) == "number" or type(cashItems) == "string" then
    return to_number_safe(cashItems)
  end
  if type(cashItems) == "table" then
    local total = 0
    for _, entry in pairs(cashItems) do
      total = total + to_number_safe(entry)
    end
    return total
  end

  return 0
end

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

  local identity = vRP.userIdentity(userId)
  local groups = vRP.userGroups(userId) or {}

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
    cash = getTotalCashMoney(source) or 0,
    bank = tonumber(vRP.getBank(userId)) or 0,
  }

  return {
    source = source,
    identifier = tostring(userId),
    name = ("%s %s"):format(identity.name , identity.name2),
    firstName = identity.name,
    lastName = identity.name2,
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
  local identity = vRP.userIdentity and vRP.userIdentity(userId) or {}
  return identity.name .. " " .. identity.name2
end

function Framework.getJob(source)
  local userId = getUserId(source)
  if not userId then return nil end

  local groups = vRP.userGroups(userId) or {}
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
    return getTotalCashMoney(source) or 0
  elseif moneyType == "bank" then
    return tonumber(vRP.getBank(userId)) or 0
  end

  return 0
end

function Framework.addMoney(source, moneyType, amount, reason)
  local userId = getUserId(source)
  if not userId then return false end

  moneyType = moneyType or "cash"

  if moneyType == "cash" then
    if vRP.giveInventoryItem then
      vRP.giveInventoryItem(userId, "dollars", amount, true)
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
    return vRP.tryGetInventoryItem(userId,"dollars", amount)
  elseif moneyType == "bank" then
    return vRP.paymentBank(userId, amount)
  end

  return false
end

function Framework.hasGroup(source, group, minGrade)
  local userId = getUserId(source)
  if not userId then return false end

  return vRP.hasGroup(userId, group) or false
end

function Framework.isAdmin(source)
  local userId = getUserId(source)
  if not userId then return false end

  return Framework.hasGroup(userId, "Admin") or IsPlayerAceAllowed(tostring(source), "command")
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