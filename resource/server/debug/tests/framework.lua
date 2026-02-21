return function(tests, ui)

  local function logResult(src, action, data)
    print(("^2[retro-kit]^7 [framework:%s] %s"):format(action, data))
    ui.notify(src, {
      style = "info",
      title = "Framework Debug",
      description = ("[%s] %s"):format(action, data),
    })
  end

  local function logError(src, action, data)
    print(("^1[retro-kit]^7 [framework:%s] %s"):format(action, data))
    ui.notify(src, {
      style = "error",
      title = "Framework Debug",
      description = ("[%s] %s"):format(action, data),
    })
  end

  local function getFramework()
    return exports['retro-kit']:GetBridgeFramework()
  end

  -- /retro framework
  tests["framework"] = function(src)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "status", "No framework available")
      return
    end
    logResult(src, "status", ("Active: %s"):format(fw.name))
  end

  -- /retro framework:player
  tests["framework:player"] = function(src)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "player", "No framework available")
      return
    end

    local player = fw.getPlayer(src)
    if not player then
      logError(src, "player", "Player not found")
      return
    end

    print(("^2[retro-kit]^7 [framework:player] Full data:"):format())
    print(("  Identifier: %s"):format(player.identifier or "?"))
    print(("  Name: %s"):format(player.name or "?"))
    print(("  Job: %s (%s) grade %d (%s)"):format(
      player.job.name, player.job.label, player.job.grade, player.job.gradeLabel
    ))
    if player.gang then
      print(("  Gang: %s (%s) grade %d (%s)"):format(
        player.gang.name, player.gang.label, player.gang.grade, player.gang.gradeLabel
      ))
    end

    logResult(src, "player", ("%s | %s | %s"):format(
      player.name, player.job.name, player.identifier
    ))
  end

  -- /retro framework:money
  tests["framework:money"] = function(src)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "money", "No framework available")
      return
    end

    local cash = fw.getMoney(src, "cash")
    local bank = fw.getMoney(src, "bank")

    logResult(src, "money", ("Cash: $%d | Bank: $%d"):format(cash, bank))
  end

  -- /retro framework:addmoney <type> <amount>
  tests["framework:addmoney"] = function(src, args)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "addmoney", "No framework available")
      return
    end

    local moneyType = args[2] or "cash"
    local amount = tonumber(args[3]) or 1000

    local success = fw.addMoney(src, moneyType, amount, "retro-kit debug")
    if success then
      logResult(src, "addmoney", ("addMoney('%s', %d) = SUCCESS"):format(moneyType, amount))
    else
      logError(src, "addmoney", ("addMoney('%s', %d) = FAILED"):format(moneyType, amount))
    end
  end

  -- /retro framework:removemoney <type> <amount>
  tests["framework:removemoney"] = function(src, args)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "removemoney", "No framework available")
      return
    end

    local moneyType = args[2] or "cash"
    local amount = tonumber(args[3]) or 1000

    local success = fw.removeMoney(src, moneyType, amount, "retro-kit debug")
    if success then
      logResult(src, "removemoney", ("removeMoney('%s', %d) = SUCCESS"):format(moneyType, amount))
    else
      logError(src, "removemoney", ("removeMoney('%s', %d) = FAILED"):format(moneyType, amount))
    end
  end

  -- /retro framework:job
  tests["framework:job"] = function(src)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "job", "No framework available")
      return
    end

    local job = fw.getJob(src)
    if not job then
      logError(src, "job", "No job data found")
      return
    end

    logResult(src, "job", ("%s (%s) | Grade: %d (%s) | OnDuty: %s"):format(
      job.name, job.label, job.grade, job.gradeLabel, tostring(job.onDuty)
    ))
  end

  -- /retro framework:hasgroup <group> [minGrade]
  tests["framework:hasgroup"] = function(src, args)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "hasgroup", "No framework available")
      return
    end

    local group = args[2]
    if not group then
      logError(src, "hasgroup", "Usage: /retro framework:hasgroup <group> [minGrade]")
      return
    end

    local minGrade = tonumber(args[3]) or 0
    local has = fw.hasGroup(src, group, minGrade)

    logResult(src, "hasgroup", ("hasGroup('%s', %d) = %s"):format(group, minGrade, tostring(has)))
  end

  -- /retro framework:admin
  tests["framework:admin"] = function(src)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "admin", "No framework available")
      return
    end

    local isAdmin = fw.isAdmin(src)
    logResult(src, "admin", ("isAdmin = %s"):format(tostring(isAdmin)))
  end

  -- /retro framework:players
  tests["framework:players"] = function(src)
    local fw = getFramework()
    if not fw or not fw.isAvailable() then
      logError(src, "players", "No framework available")
      return
    end

    local players = fw.getPlayers()
    local count = fw.getPlayerCount()

    print(("^2[retro-kit]^7 [framework:players] %d players online:"):format(count))
    for _, playerId in ipairs(players) do
      local name = fw.getName(playerId) or "Unknown"
      print(("  - ID %d: %s"):format(playerId, name))
    end

    logResult(src, "players", ("%d players online"):format(count))
  end

end