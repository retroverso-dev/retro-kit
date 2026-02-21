-- ══════════════════════════════════════════
-- CREATIVE FRAMEWORK BRIDGE
-- ══════════════════════════════════════════

local Framework = {}

Framework.name = "creative"

local function getPlayer(source)
  local success, player = pcall(function()
    return exports['creative_core']:GetPlayer(source)
  end)
  if success and player then return player end
  return nil
end

function Framework.isAvailable()
  return true
end

function Framework.getPlayer(source)
  local player = getPlayer(source)
  if not player then return nil end

  local charInfo = player.charinfo or player.CharInfo or {}
  local jobData = player.job or player.Job or {}
  local moneyData = player.money or player.Money or {}

  return {
    source = source,
    identifier = player.identifier or player.citizenid or tostring(source),
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
    dob = charInfo.birthdate or charInfo.dob,
    gender = charInfo.gender or charInfo.sex,
    phone = charInfo.phone,
  }
end

function Framework.getIdentifier(source)
  local player = getPlayer(source)
  if not player then return nil end
  return player.identifier or player.citizenid or nil
end

function Framework.getName(source)
  local data = Framework.getPlayer(source)
  return data and data.name or nil
end

function Framework.getJob(source)
  local data = Framework.getPlayer(source)
  return data and data.job or nil
end

function Framework.getGang(source)
  return nil
end

function Framework.getMoney(source, moneyType)
  local data = Framework.getPlayer(source)
  if not data then return 0 end
  moneyType = moneyType or "cash"
  return data.money[moneyType] or 0
end

function Framework.addMoney(source, moneyType, amount, reason)
  local player = getPlayer(source)
  if not player then return false end

  moneyType = moneyType or "cash"

  local success, result = pcall(function()
    if player.addMoney then
      return player.addMoney(moneyType, amount, reason)
    elseif player.AddMoney then
      return player.AddMoney(moneyType, amount, reason)
    end
    return false
  end)

  return success and result or false
end

function Framework.removeMoney(source, moneyType, amount, reason)
  local player = getPlayer(source)
  if not player then return false end

  moneyType = moneyType or "cash"

  local data = Framework.getPlayer(source)
  if data and (data.money[moneyType] or 0) < amount then
    return false
  end

  local success, result = pcall(function()
    if player.removeMoney then
      return player.removeMoney(moneyType, amount, reason)
    elseif player.RemoveMoney then
      return player.RemoveMoney(moneyType, amount, reason)
    end
    return false
  end)

  return success and result or false
end

function Framework.hasGroup(source, group, minGrade)
  local data = Framework.getPlayer(source)
  if not data then return false end
  minGrade = minGrade or 0
  return data.job.name == group and data.job.grade >= minGrade
end

function Framework.isAdmin(source)
  local player = getPlayer(source)
  if not player then return false end

  local success, result = pcall(function()
    if player.hasPermission then
      return player.hasPermission("admin")
    elseif player.HasPermission then
      return player.HasPermission("admin")
    end
    return false
  end)

  return (success and result) or IsPlayerAceAllowed(tostring(source), "command")
end

function Framework.notify(source, message, type)
  TriggerClientEvent("chat:addMessage", source, { args = { "[Server]", message } })
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