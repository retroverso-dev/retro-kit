# retro-kit Documentation

A collection of UI tools and resources for FiveM development.

## Table of Contents

- [Getting Started](./getting-started.md)
- [Notifications](./notifications.md)
- [Alert Dialogs](./alert-dialog.md)
- [Progress Bar](./progress-bar.md)
- [Circle Progress](./circle-progress.md)
- [Context Menu](./context-menu.md)
- [Text UI](./text-ui.md)
- [Input Dialog](./input-dialog.md)
- [Configuration](./configuration.md)

### Bridge

- [Framework Bridge](./bridge/framework/index.md) — QBCore, ESX, QBox, vRPex, Creative
- [Inventory Bridge](./bridge/inventory/index.md) — ox_inventory, qb-inventory, ESX
- [Target Bridge](./bridge/target/index.md) — ox_target, qb-target

## Quick Start

1. Ensure `retro-kit` is running on your server.
2. Add it as a dependency in your resource:

```lua
-- fxmanifest.lua
dependency 'retro-kit'

shared_scripts {
    '@retro-kit/init.lua',
}
```

3. Use the `retro` global anywhere in your scripts:

```lua
-- Notifications
retro.notify(playerId, {
    style = "success",
    title = "Hello!",
    description = "retro-kit is working.",
})
```

```lua
-- Framework (server-side)
local player = retro.bridge.framework.getPlayer(source)
print(player.name)       -- "John Doe"
print(player.job.name)   -- "police"
print(player.money.cash) -- 5000

retro.bridge.framework.addMoney(source, "cash", 5000, "salary")

if retro.bridge.framework.hasGroup(source, "police", 2) then
  -- police grade 2+ logic
end
```

```lua
-- Inventory (server-side)
if retro.bridge.inventory.hasItem(source, "water", 1) then
  retro.bridge.inventory.removeItem(source, "water", 1)
end
```
