# Framework Bridge

Unified API for interacting with framework systems. Configure once in `config.lua` and use a single API regardless of the underlying framework.

## Configuration

```lua
-- config.lua
Config.Bridge = {
  framework = "auto", -- "qbcore", "esx", "qbox", "vrpex", "creative", "none" or "auto"
}
```

| Value                             | Description                        |
| --------------------------------- | ---------------------------------- |
| `"auto"`                          | Auto-detect from running resources |
| `"qbcore"` / `"qb-core"` / `"qb"` | Use QBCore                         |
| `"esx"` / `"es_extended"`         | Use ESX                            |
| `"qbox"` / `"qbx"` / `"qbx_core"` | Use QBox                           |
| `"vrpex"` / `"vrp"`               | Use vRPex                          |
| `"creative"` / `"creative_core"`  | Use Creative                       |
| `"none"` / `"disabled"`           | Disable framework bridge           |

## Supported Frameworks

| Feature       | QBCore | ESX | QBox | vRPex   | Creative | None |
| ------------- | ------ | --- | ---- | ------- | -------- | ---- |
| getPlayer     | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| getIdentifier | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| getName       | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| getJob        | ✅     | ✅  | ✅   | ⚠️ \*   | ✅       | —    |
| getGang       | ✅     | —   | ✅   | —       | —        | —    |
| getMoney      | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| addMoney      | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| removeMoney   | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| hasGroup      | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| isAdmin       | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| getPlayers    | ✅     | ✅  | ✅   | ✅      | ✅       | —    |
| Client-side   | ✅     | ✅  | ✅   | ⚠️ \*\* | ✅       | —    |

\* vRPex jobs are derived from user groups. The first group is used as the "job".
\*\* vRPex client bridge has limited functionality — most data is server-side only via Proxy.

---

## Usage

### Via `retro.bridge.framework` (Server)

Requires `@retro-kit/init.lua` in your `shared_scripts`.

```lua
-- Get full player data (server-side)
local player = retro.bridge.framework.getPlayer(source)
if player then
  print(player.name)           -- "John Doe"
  print(player.identifier)     -- "ABC12345" (citizenid, license, etc.)
  print(player.job.name)       -- "police"
  print(player.job.grade)      -- 3
  print(player.money.cash)     -- 5000
  print(player.money.bank)     -- 25000
end
```

```lua
-- Check job/gang membership
if retro.bridge.framework.hasGroup(source, "police", 2) then
  print("Player is police grade 2+")
end

-- Also checks gangs on QBCore/QBox
if retro.bridge.framework.hasGroup(source, "ballas") then
  print("Player is in ballas gang")
end
```

```lua
-- Money operations
local cash = retro.bridge.framework.getMoney(source, "cash")
local bank = retro.bridge.framework.getMoney(source, "bank")

retro.bridge.framework.addMoney(source, "cash", 5000, "salary payment")
retro.bridge.framework.removeMoney(source, "bank", 1000, "purchase")
```

```lua
-- Admin check
if retro.bridge.framework.isAdmin(source) then
  print("Player is admin")
end
```

```lua
-- Get all online players
local players = retro.bridge.framework.getPlayers()
local count = retro.bridge.framework.getPlayerCount()

for _, playerId in ipairs(players) do
  local name = retro.bridge.framework.getName(playerId)
  print(("ID %d: %s"):format(playerId, name))
end
```

### Via `retro.bridge.framework` (Client)

```lua
-- Get local player data (client-side)
local player = retro.bridge.framework.getPlayerData()
if player then
  print(player.name)
  print(player.job.name)
  print(player.money.cash)
end
```

```lua
-- Quick accessors (client-side)
local job = retro.bridge.framework.getJob()
local gang = retro.bridge.framework.getGang()       -- QBCore/QBox only
local cash = retro.bridge.framework.getMoney("cash")
local id = retro.bridge.framework.getIdentifier()
local name = retro.bridge.framework.getName()
```

```lua
-- Check group (client-side)
if retro.bridge.framework.hasGroup("police", 2) then
  -- show police UI
end
```

### Via Export

```lua
-- Server
local fw = exports['retro-kit']:GetBridgeFramework()
if fw and fw.isAvailable() then
  local player = fw.getPlayer(source)
end

-- Client
local fw = exports['retro-kit']:GetBridgeFramework()
if fw and fw.isAvailable() then
  local player = fw.getPlayerData()
end
```

### Checking Availability

```lua
if retro.bridge.framework.isAvailable() then
  local player = retro.bridge.framework.getPlayer(source)
else
  print("No framework detected")
end
```

```lua
-- Check which framework is active
local name = retro.bridge.framework.getBridgeName()
-- Returns: "qbcore", "esx", "qbox", "vrpex", "creative", or "none"
```

---

## API Reference

### Availability

```lua
retro.bridge.framework.isAvailable()    -- returns boolean
retro.bridge.framework.getBridgeName()  -- returns "qbcore" | "esx" | "qbox" | "vrpex" | "creative" | "none"
```

### Server-Side Functions

#### getPlayer

Returns full normalized player data.

```lua
retro.bridge.framework.getPlayer(source) -- returns PlayerData | nil
```

**PlayerData structure:**

```lua
{
  source     = 1,                  -- number: server ID
  identifier = "ABC12345",         -- string: unique ID (citizenid, license, vRP userId)
  name       = "John Doe",         -- string: full character name
  firstName  = "John",             -- string: first name
  lastName   = "Doe",              -- string: last name
  job = {
    name       = "police",         -- string: job identifier
    label      = "Police",         -- string: display name
    grade      = 3,                -- number: grade level
    gradeLabel = "Sergeant",       -- string: grade display name
    onDuty     = true,             -- boolean|nil: duty status (QBCore/QBox)
  },
  gang = {                         -- nil on ESX/vRPex/Creative
    name       = "ballas",
    label      = "Ballas",
    grade      = 1,
    gradeLabel = "Member",
  },
  money = {
    cash   = 5000,                 -- number: cash balance
    bank   = 25000,                -- number: bank balance
    crypto = 100,                  -- number|nil: crypto (QBCore/QBox)
  },
  dob    = "1990-01-15",           -- string|nil: date of birth
  gender = 0,                      -- number|nil: 0 = male, 1 = female
  phone  = "555-0123",             -- string|nil: phone number
}
```

#### getIdentifier

```lua
retro.bridge.framework.getIdentifier(source) -- returns string | nil
```

| Framework | Returns                     |
| --------- | --------------------------- |
| QBCore    | `citizenid`                 |
| ESX       | `license:xxxxx` or similar  |
| QBox      | `citizenid`                 |
| vRPex     | vRP `user_id` as string     |
| Creative  | `identifier` or `citizenid` |

#### getName

```lua
retro.bridge.framework.getName(source) -- returns string | nil
```

Returns the character's full name (`firstName lastName`).

#### getJob

```lua
retro.bridge.framework.getJob(source) -- returns JobData | nil
```

#### getGang

```lua
retro.bridge.framework.getGang(source) -- returns GangData | nil
```

> Only QBCore and QBox have native gang support. Returns `nil` on other frameworks.

#### getMoney / addMoney / removeMoney

```lua
retro.bridge.framework.getMoney(source, moneyType?)                   -- returns number
retro.bridge.framework.addMoney(source, moneyType, amount, reason?)   -- returns boolean
retro.bridge.framework.removeMoney(source, moneyType, amount, reason?) -- returns boolean
```

| moneyType  | QBCore   | ESX          | QBox     | vRPex          | Creative |
| ---------- | -------- | ------------ | -------- | -------------- | -------- |
| `"cash"`   | `cash`   | `money` acct | `cash`   | `getMoney`     | `cash`   |
| `"bank"`   | `bank`   | `bank` acct  | `bank`   | `getBankMoney` | `bank`   |
| `"crypto"` | `crypto` | —            | `crypto` | —              | —        |

> `removeMoney` validates balance before removing and returns `false` if insufficient funds (on ESX and vRPex).

#### hasGroup

```lua
retro.bridge.framework.hasGroup(source, group, minGrade?) -- returns boolean
```

Checks if the player's **job** or **gang** matches `group` with at least `minGrade` (default `0`).

```lua
-- Check if player is police (any grade)
retro.bridge.framework.hasGroup(source, "police")

-- Check if player is police sergeant or higher (grade 3+)
retro.bridge.framework.hasGroup(source, "police", 3)

-- Check gang membership (QBCore/QBox)
retro.bridge.framework.hasGroup(source, "ballas")

-- On vRPex, checks vRP groups
retro.bridge.framework.hasGroup(source, "admin")
```

#### isAdmin

```lua
retro.bridge.framework.isAdmin(source) -- returns boolean
```

| Framework | How it checks                                       |
| --------- | --------------------------------------------------- |
| QBCore    | `QBCore.Functions.HasPermission(source, "admin")`   |
| ESX       | `xPlayer.getGroup() == "admin" or "superadmin"`     |
| QBox      | `exports.qbx_core:HasPermission(source, "admin")`   |
| vRPex     | `vRP.hasPermission(userId, "admin.permall")`        |
| Creative  | `player.hasPermission("admin")`                     |
| All       | Also checks `IsPlayerAceAllowed(source, "command")` |

#### notify

```lua
retro.bridge.framework.notify(source, message, type?) -- returns nil
```

Sends a notification using the framework's native notification system.

> **Note:** For better notifications, use `retro.notify()` instead. This function is for framework-native fallback.

#### getPlayers / getPlayerCount

```lua
retro.bridge.framework.getPlayers()     -- returns number[]
retro.bridge.framework.getPlayerCount() -- returns number
```

### Client-Side Functions

| Function                     | Returns             | Description                |
| ---------------------------- | ------------------- | -------------------------- |
| `getPlayerData()`            | `PlayerData \| nil` | Full local player data     |
| `getJob()`                   | `JobData \| nil`    | Current job                |
| `getGang()`                  | `GangData \| nil`   | Current gang (QBCore/QBox) |
| `getMoney(moneyType?)`       | `number`            | Money balance              |
| `hasGroup(group, minGrade?)` | `boolean`           | Check job/gang             |
| `getIdentifier()`            | `string \| nil`     | Player identifier          |
| `getName()`                  | `string \| nil`     | Character name             |

> Client-side functions don't take `source` — they always refer to the local player.

---

## Adding Your Own Framework Bridge

### 1. Create the Bridge Directory

```
resource/bridge/framework/
├── none/
│   ├── server.lua
│   └── client.lua
├── qbcore/
│   ├── server.lua
│   └── client.lua
└── my-framework/          ← your new bridge
    ├── server.lua
    └── client.lua
```

### 2. Create `server.lua`

```lua
-- filepath: resource/bridge/framework/my-framework/server.lua

local Framework = {}

Framework.name = "my-framework"

function Framework.isAvailable()
  return GetResourceState("my-framework") == "started"
end

function Framework.getPlayer(source)
  local player = exports['my-framework']:GetPlayer(source)
  if not player then return nil end

  -- IMPORTANT: normalize to standard PlayerData format
  return {
    source     = source,
    identifier = player.id,
    name       = player.fullName,
    firstName  = player.first,
    lastName   = player.last,
    job = {
      name       = player.job.id,
      label      = player.job.name,
      grade      = player.job.rank,
      gradeLabel = player.job.rankName,
      onDuty     = player.job.duty,
    },
    gang  = nil,
    money = {
      cash = player.wallet,
      bank = player.account,
    },
  }
end

function Framework.getIdentifier(source)
  -- return unique player identifier
end

function Framework.getName(source)
  -- return "FirstName LastName"
end

function Framework.getJob(source)
  -- return JobData table
end

function Framework.getGang(source)
  -- return GangData table or nil
end

function Framework.getMoney(source, moneyType)
  -- return number
end

function Framework.addMoney(source, moneyType, amount, reason)
  -- return boolean
end

function Framework.removeMoney(source, moneyType, amount, reason)
  -- return boolean (false if insufficient funds)
end

function Framework.hasGroup(source, group, minGrade)
  -- return boolean
end

function Framework.isAdmin(source)
  -- return boolean
end

function Framework.notify(source, message, type)
  -- send native notification
end

function Framework.getPlayers()
  -- return number[] of online source IDs
end

function Framework.getPlayerCount()
  -- return number
end

return Framework
```

### 3. Create `client.lua`

```lua
-- filepath: resource/bridge/framework/my-framework/client.lua

local Framework = {}

Framework.name = "my-framework"

function Framework.isAvailable()
  return true
end

function Framework.getPlayerData()
  -- return PlayerData for local player (no source param)
end

function Framework.getJob()
  -- return JobData
end

function Framework.getGang()
  -- return GangData or nil
end

function Framework.getMoney(moneyType)
  -- return number
end

function Framework.hasGroup(group, minGrade)
  -- return boolean
end

function Framework.getIdentifier()
  -- return string
end

function Framework.getName()
  -- return string
end

return Framework
```

### 4. Register Aliases

In `resource/bridge/init.lua`, add to `detectFramework()`:

```lua
local aliases = {
  -- ...existing aliases...
  ["my-framework"]  = "my-framework",
  ["myfw"]          = "my-framework",
}
```

And for auto-detection:

```lua
if configured == "auto" then
  -- ...existing checks...
  elseif isResourceStarted("my-framework") then
    return "my-framework"
  -- ...
end
```

### 5. Configure

```lua
Config.Bridge = {
  framework = "my-framework",
}
```

### 6. Important Rules

- **Always normalize** data to the standard `PlayerData`, `JobData`, `GangData`, `MoneyData` formats
- **Server bridge** must implement all 14 functions
- **Client bridge** must implement all 8 functions
- **Return correct types** — `nil` for not found, `0` for money, `false` for failures
- Both files must `return` the table
- If a feature isn't supported (e.g., gangs), return `nil`
- `removeMoney` should validate balance and return `false` if insufficient

---

## Debug Commands

When `Config.debug = true`:

```
/retro framework                          -- Show which framework is active
/retro framework:player                   -- Full player data (identifier, name, job, gang, money)
/retro framework:money                    -- Show cash and bank balances
/retro framework:addmoney cash 5000       -- Add money (type: cash/bank/crypto)
/retro framework:removemoney bank 1000    -- Remove money
/retro framework:job                      -- Show job name, label, grade, onDuty
/retro framework:gang                     -- Show gang info (QBCore/QBox only)
/retro framework:hasgroup police 2        -- Check group membership with min grade
/retro framework:admin                    -- Check if player is admin
/retro framework:players                  -- List all online players with names
/retro framework:id                       -- Show player identifier
```

### Example Output

```
/retro framework
  ^2[retro-kit]^7 [framework:status] Active: qbcore

/retro framework:player
  ^2[retro-kit]^7 [framework:player] Full data:
    Identifier: ABC12345
    Name: John Doe
    Job: police (Police) grade 3 (Sergeant)
    Gang: ballas (Ballas) grade 1 (Member)
    Cash: $5000 | Bank: $25000
  ^2[retro-kit]^7 [framework:player] John Doe | police | ABC12345

/retro framework:money
  ^2[retro-kit]^7 [framework:money] Cash: $5000 | Bank: $25000

/retro framework:hasgroup police 2
  ^2[retro-kit]^7 [framework:hasgroup] hasGroup('police', 2) = true

/retro framework:admin
  ^2[retro-kit]^7 [framework:admin] isAdmin = true
```
