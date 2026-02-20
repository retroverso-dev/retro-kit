# Target Bridge

Unified API for interacting with target systems (`ox_target`, `qb-target`). Configure once in `config.lua` and use a single API regardless of the underlying target resource.

## Configuration

```lua
-- config.lua
Config.Bridge = {
  target = "ox_target", -- "ox_target", "qb-target", "none" or "auto"
}
```

| Value                   | Description                        |
| ----------------------- | ---------------------------------- |
| `"auto"`                | Auto-detect from running resources |
| `"ox_target"` / `"ox"`  | Use ox_target                      |
| `"qb-target"` / `"qb"`  | Use qb-target                      |
| `"none"` / `"disabled"` | Disable target system              |

## Usage

### Via `retro.bridge.target`

Requires `@retro-kit/init.lua` in your `shared_scripts`.

```lua
-- client-side only
retro.bridge.target.addBoxZone({
  name = "my_zone",
  coords = vec3(100.0, 200.0, 30.0),
  size = vec3(3.0, 3.0, 3.0),
  debug = true,
  options = {
    {
      name = "my_interaction",
      label = "Interact",
      icon = "fas fa-hand",
      distance = 2.5,
      onSelect = function(data)
        print("Interacted!", data.entity, data.coords)
      end,
    },
  },
})
```

### Via Export

```lua
local target = exports['retro-kit']:GetBridgeTarget()
if target then
  target.addModel("prop_atm_01", { ... })
end
```

### Checking Availability

You can check if a target system is available before using it, and handle fallbacks accordingly.

```lua
-- Check if any target system is loaded
if retro.bridge.target.isAvailable() then
  retro.bridge.target.addEntity(vehicle, {
    {
      name = "open_trunk",
      label = "Open Trunk",
      icon = "fas fa-box-open",
      distance = 2.5,
      onSelect = function(data)
        -- open trunk logic
      end,
    },
  })
else
  -- Fallback: use keybind, drawtext, prompt, etc.
  print("No target system available, using fallback")
end
```

```lua
-- Check which target system is active
local name = retro.bridge.target.getName()
-- Returns: "ox_target", "qb-target", or "none"

if name == "none" then
  -- no target system
elseif name == "ox_target" then
  -- ox_target specific logic (if needed)
end
```

```lua
-- Check the return value of any function
-- Returns true if executed, false if target is "none"
local success = retro.bridge.target.addModel("prop_atm_01", {
  {
    name = "use_atm",
    label = "Use ATM",
    icon = "fas fa-money-bill",
    distance = 2.0,
    onSelect = function(data)
      -- atm logic
    end,
  },
})

if not success then
  print("Target not available, interaction was not registered")
end
```

## API Reference

### Availability

```lua
retro.bridge.target.isAvailable()   -- returns boolean
retro.bridge.target.getName()       -- returns "ox_target" | "qb-target" | "none"
```

### Entity

```lua
-- Add interaction to specific entity handles
retro.bridge.target.addEntity(entities, options)
retro.bridge.target.removeEntity(entities, optionNames?)
```

| Parameter     | Type            | Description                       |
| ------------- | --------------- | --------------------------------- |
| `entities`    | `number\|table` | Entity handle or array of handles |
| `options`     | `table`         | Array of option definitions       |
| `optionNames` | `table?`        | Array of option names to remove   |

### Model

```lua
-- Add interaction to all entities of a model
retro.bridge.target.addModel(models, options)
retro.bridge.target.removeModel(models, optionNames?)
```

| Parameter     | Type            | Description                        |
| ------------- | --------------- | ---------------------------------- |
| `models`      | `string\|table` | Model name or array of model names |
| `options`     | `table`         | Array of option definitions        |
| `optionNames` | `table?`        | Array of option names to remove    |

### Global Player

```lua
retro.bridge.target.addGlobalPlayer(options)
retro.bridge.target.removeGlobalPlayer(optionNames?)
```

### Global Ped

```lua
retro.bridge.target.addGlobalPed(options)
retro.bridge.target.removeGlobalPed(optionNames?)
```

### Global Vehicle

```lua
retro.bridge.target.addGlobalVehicle(options)
retro.bridge.target.removeGlobalVehicle(optionNames?)
```

### Global Object

```lua
retro.bridge.target.addGlobalObject(options)
retro.bridge.target.removeGlobalObject(optionNames?)
```

### Box Zone

```lua
retro.bridge.target.addBoxZone(params)
```

| Parameter  | Type      | Required | Default         | Description                 |
| ---------- | --------- | -------- | --------------- | --------------------------- |
| `name`     | `string`  | ✅       | —               | Unique zone identifier      |
| `coords`   | `vec3`    | ✅       | —               | Center coordinates          |
| `size`     | `vec3`    | ❌       | `vec3(2, 2, 2)` | Zone dimensions             |
| `rotation` | `vec3`    | ❌       | `nil`           | Zone rotation (uses `.z`)   |
| `debug`    | `boolean` | ❌       | `false`         | Show debug polygon          |
| `options`  | `table`   | ✅       | —               | Array of option definitions |
| `distance` | `number`  | ❌       | `2.0`           | Interaction distance        |

### Sphere Zone

```lua
retro.bridge.target.addSphereZone(params)
```

| Parameter | Type      | Required | Default | Description                       |
| --------- | --------- | -------- | ------- | --------------------------------- |
| `name`    | `string`  | ✅       | —       | Unique zone identifier            |
| `coords`  | `vec3`    | ✅       | —       | Center coordinates                |
| `size`    | `vec3`    | ❌       | `nil`   | Uses `.x` as radius (default 2.0) |
| `debug`   | `boolean` | ❌       | `false` | Show debug sphere                 |
| `options` | `table`   | ✅       | —       | Array of option definitions       |

### Remove Zone

```lua
retro.bridge.target.removeZone(name)
```

### Disable Targeting

```lua
retro.bridge.target.disableTargeting(state)
```

## Option Definition

```lua
{
  name = "unique_option_name",    -- string (required) unique identifier
  label = "Interact",             -- string (required) display label
  icon = "fas fa-hand",           -- string (optional) FontAwesome icon
  distance = 2.0,                 -- number (optional) max interaction distance
  groups = { "police" },          -- table  (optional) job/group restriction
  items = { "lockpick" },         -- table  (optional) required items
  canInteract = function(entity, distance, coords, name)
    return true                   -- boolean, return false to hide option
  end,
  onSelect = function(data)
    -- data.entity   (number)  entity handle
    -- data.coords   (vec3)    entity coordinates
    -- data.distance (number)  distance to entity
    -- data.name     (string)  option name
  end,
}
```

## Supported Targets

| Target      | Entity | Model | Global | Zones | Disable |
| ----------- | ------ | ----- | ------ | ----- | ------- |
| `ox_target` | ✅     | ✅    | ✅     | ✅    | ✅      |
| `qb-target` | ✅     | ✅    | ✅     | ✅    | ⚠️ \*   |
| `none`      | —      | —     | —      | —     | —       |

\* `qb-target` disable uses `LocalPlayer.state` as workaround.

## Debug Commands

When `Config.debug = true`:

```
/retro target:box        -- Creates a debug box zone at your position
/retro target:entity     -- Adds target to your current vehicle
/retro target:model      -- Adds target to ATMs (prop_atm_01)
/retro target:globalped  -- Adds target to all peds
```
