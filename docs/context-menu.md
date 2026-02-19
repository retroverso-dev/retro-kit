# Context Menu

Display a context menu with customizable buttons, submenus, metadata, progress indicators, and event dispatching.

## Server API

### Using `retro` global

```lua
retro.registerContext(player, id, data, clickCallbacks)
retro.showContext(player, id)
retro.hideContext(player)
```

### Using exports

```lua
exports['retro-kit']:RegisterContext(player, id, data, clickCallbacks)
exports['retro-kit']:ShowContext(player, id)
exports['retro-kit']:HideContext(player)
```

## Parameters

### `retro.registerContext`

| Parameter        | Type     | Required | Default | Description                                                           |
| ---------------- | -------- | -------- | ------- | --------------------------------------------------------------------- |
| `player`         | `number` | ✅       | —       | Server ID of the target player                                        |
| `id`             | `string` | ✅       | —       | Unique menu identifier                                                |
| `data`           | `table`  | ✅       | —       | Menu definition (see below)                                           |
| `clickCallbacks` | `table`  | ❌       | `nil`   | Callbacks keyed by option ID (only works inside `retro-kit` resource) |

### `retro.showContext`

| Parameter | Type     | Required | Default | Description                        |
| --------- | -------- | -------- | ------- | ---------------------------------- |
| `player`  | `number` | ✅       | —       | Server ID of the target player     |
| `id`      | `string` | ✅       | —       | Menu ID (must be registered first) |

### `retro.hideContext`

| Parameter | Type     | Required | Default | Description                    |
| --------- | -------- | -------- | ------- | ------------------------------ |
| `player`  | `number` | ✅       | —       | Server ID of the target player |

## Menu Data Properties

| Property      | Type      | Required | Default | Description                                     |
| ------------- | --------- | -------- | ------- | ----------------------------------------------- |
| `title`       | `string`  | ✅       | —       | Title displayed at the top of the menu          |
| `description` | `string`  | ❌       | `nil`   | Description displayed below the title           |
| `menu`        | `string`  | ❌       | `nil`   | Parent menu ID (enables back button)            |
| `canClose`    | `boolean` | ❌       | `true`  | Allow closing the menu with ESC or close button |
| `options`     | `table`   | ✅       | —       | Table of options keyed by ID (see below)        |

## Option Properties

| Property        | Type      | Required | Default | Description                                                   |
| --------------- | --------- | -------- | ------- | ------------------------------------------------------------- |
| `title`         | `string`  | ❌       | `nil`   | Button label                                                  |
| `description`   | `string`  | ❌       | `nil`   | Secondary text below the title                                |
| `icon`          | `string`  | ❌       | `nil`   | Lucide icon name (e.g. `"Heart"`, `"Shield"`)                 |
| `iconColor`     | `string`  | ❌       | `nil`   | Icon color (CSS color or Tailwind class, e.g. `"#ef4444"`)    |
| `iconAnimation` | `string`  | ❌       | `nil`   | Icon animation: `"spin"`, `"pulse"`, `"bounce"`, `"shake"`    |
| `image`         | `string`  | ❌       | `nil`   | Image URL (used as fallback if no icon is set)                |
| `progress`      | `number`  | ❌       | `nil`   | Progress bar value (0–100) displayed below the button content |
| `colorScheme`   | `string`  | ❌       | `nil`   | Color for the progress bar (CSS color, e.g. `"#22c55e"`)      |
| `metadata`      | `table`   | ❌       | `nil`   | Additional data displayed below the button (see below)        |
| `menu`          | `string`  | ❌       | `nil`   | Submenu ID to navigate to when clicked                        |
| `arrow`         | `boolean` | ❌       | `true`  | Show chevron arrow (only when `menu` is set)                  |
| `event`         | `string`  | ❌       | `nil`   | Client event to trigger when clicked                          |
| `serverEvent`   | `string`  | ❌       | `nil`   | Server event to trigger when clicked                          |
| `args`          | `any`     | ❌       | `nil`   | Arguments passed to the event or callback                     |
| `disabled`      | `boolean` | ❌       | `false` | Disable the button (greyed out, not clickable)                |
| `readOnly`      | `boolean` | ❌       | `false` | Button is visible but clicking does nothing                   |

## Metadata Formats

Metadata can be provided in three different formats:

### String Array

Displays a list of plain text lines.

```lua
metadata = {
    "Line one of information",
    "Line two of information",
}
```

### Key-Value Table

Displays label-value pairs side by side.

```lua
metadata = {
    Health = "100%",
    Armor = "50%",
    Cash = "$12,500",
}
```

### Structured Array

Displays label-value pairs with optional progress bars.

```lua
metadata = {
    { label = "Driving",  value = "Advanced",     progress = 85, colorScheme = "#22c55e" },
    { label = "Shooting", value = "Intermediate", progress = 55, colorScheme = "#eab308" },
    { label = "Stealth",  value = "Beginner",     progress = 20, colorScheme = "#ef4444" },
}
```

| Property      | Type     | Required | Default | Description                       |
| ------------- | -------- | -------- | ------- | --------------------------------- |
| `label`       | `string` | ✅       | —       | Label text                        |
| `value`       | `any`    | ✅       | —       | Value displayed next to the label |
| `progress`    | `number` | ❌       | `nil`   | Progress bar value (0–100)        |
| `colorScheme` | `string` | ❌       | `nil`   | Color for the progress bar        |

## Events

### Using `serverEvent`

When using `serverEvent`, the event is triggered as a standard FiveM server event. The `source` variable is available in the handler and contains the player's server ID.

```lua
-- Registration
retro.registerContext(source, "my_menu", {
    title = "My Menu",
    options = {
        btn_action = {
            title = "Do Something",
            icon = "Zap",
            serverEvent = "myResource:doAction",
            args = { item = "water", amount = 1 },
        },
    },
})

-- Handler (can be in any resource)
RegisterNetEvent("myResource:doAction", function(args)
    local src = source
    print(("Player %s triggered action with item: %s"):format(src, args.item))
end)
```

### Using `event`

When using `event`, a client-side event is triggered on the player who clicked.

```lua
-- Registration
retro.registerContext(source, "my_menu", {
    title = "My Menu",
    options = {
        btn_action = {
            title = "Client Action",
            icon = "Monitor",
            event = "myResource:clientAction",
            args = { key = "value" },
        },
    },
})

-- Handler (client-side)
RegisterNetEvent("myResource:clientAction", function(args)
    print("Client event triggered with: " .. args.key)
end)
```

### Using `clickCallbacks` (Internal Only)

Callbacks passed as the 4th argument to `registerContext` **only work within the `retro-kit` resource** (e.g. in debug commands). Exports cannot transfer functions between resources.

```lua
-- Only inside retro-kit resource
RetroKitServer.ui.registerContext(player, "internal_menu", {
    title = "Internal Menu",
    options = {
        btn = { title = "Click Me", icon = "Star" },
    },
}, {
    btn = function(args)
        RetroKitServer.ui.notify(player, {
            style = "success",
            title = "Clicked!",
        })
    end,
})
```

## Submenu Navigation

### Defining a Submenu

Set the `menu` property on the submenu data to reference the parent menu. This enables the back button.

```lua
-- Register parent menu
retro.registerContext(source, "main_menu", {
    title = "Main Menu",
    options = {
        open_sub = {
            title = "Open Settings",
            icon = "Settings",
            menu = "settings_menu",
        },
    },
})

-- Register submenu with back reference
retro.registerContext(source, "settings_menu", {
    title = "Settings",
    menu = "main_menu", -- enables back button to parent
    options = {
        volume = {
            title = "Volume",
            description = "Current volume level",
            icon = "Volume2",
            progress = 75,
            readOnly = true,
        },
    },
})

retro.showContext(source, "main_menu")
```

## Examples

### Basic Menu

```lua
retro.registerContext(source, "basic_menu", {
    title = "Quick Actions",
    options = {
        heal = {
            title = "Heal",
            description = "Restore health",
            icon = "Heart",
            iconColor = "#ef4444",
            serverEvent = "myResource:heal",
        },
        armor = {
            title = "Armor",
            description = "Equip armor",
            icon = "Shield",
            iconColor = "#3b82f6",
            serverEvent = "myResource:armor",
        },
    },
})

retro.showContext(source, "basic_menu")
```

### Menu with Metadata

```lua
retro.registerContext(source, "player_info", {
    title = "Player Information",
    description = "View your current stats",
    options = {
        stats = {
            title = "Statistics",
            icon = "BarChart3",
            iconColor = "#a78bfa",
            readOnly = true,
            metadata = {
                Level = "42",
                XP = "12,350 / 15,000",
                Rank = "Gold",
            },
        },
        skills = {
            title = "Skills",
            icon = "Trophy",
            iconColor = "#fbbf24",
            readOnly = true,
            metadata = {
                { label = "Driving",  value = "Advanced",     progress = 85, colorScheme = "#22c55e" },
                { label = "Shooting", value = "Intermediate", progress = 55, colorScheme = "#eab308" },
                { label = "Stealth",  value = "Beginner",     progress = 20, colorScheme = "#ef4444" },
            },
        },
    },
})

retro.showContext(source, "player_info")
```

### Menu with Progress Bar

```lua
retro.registerContext(source, "status_menu", {
    title = "Player Status",
    options = {
        health = {
            title = "Health",
            icon = "Heart",
            iconColor = "#ef4444",
            progress = 85,
            colorScheme = "#ef4444",
            readOnly = true,
        },
        stamina = {
            title = "Stamina",
            icon = "Zap",
            iconColor = "#facc15",
            progress = 60,
            colorScheme = "#eab308",
            readOnly = true,
        },
    },
})

retro.showContext(source, "status_menu")
```

### Menu with Disabled Options

```lua
retro.registerContext(source, "shop_menu", {
    title = "Weapon Shop",
    description = "Browse available weapons",
    options = {
        pistol = {
            title = "Pistol",
            description = "$500",
            icon = "Crosshair",
            serverEvent = "shop:buy",
            args = { item = "pistol", price = 500 },
        },
        rifle = {
            title = "Assault Rifle",
            description = "Requires Level 20",
            icon = "Lock",
            iconColor = "#71717a",
            disabled = true,
        },
    },
})

retro.showContext(source, "shop_menu")
```

### Menu with Submenus and Events

```lua
local src = source

-- Register submenu
retro.registerContext(src, "inventory_sub", {
    title = "Inventory",
    menu = "main", -- back button goes to "main"
    options = {
        water = {
            title = "Water Bottle",
            description = "Restores 25% thirst",
            icon = "Droplets",
            iconColor = "#60a5fa",
            serverEvent = "myResource:useItem",
            args = { item = "water" },
            metadata = {
                { label = "Quantity", value = "3x" },
                { label = "Weight", value = "0.5kg" },
            },
        },
        medkit = {
            title = "Medical Kit",
            description = "Restores 50% health",
            icon = "Heart",
            iconColor = "#f87171",
            iconAnimation = "pulse",
            serverEvent = "myResource:useItem",
            args = { item = "medkit" },
        },
    },
})

-- Register main menu
retro.registerContext(src, "main", {
    title = "Main Menu",
    canClose = true,
    options = {
        open_inventory = {
            title = "Open Inventory",
            icon = "Backpack",
            menu = "inventory_sub",
        },
        settings = {
            title = "Settings",
            icon = "Settings",
            iconAnimation = "spin",
            serverEvent = "myResource:openSettings",
        },
    },
})

retro.showContext(src, "main")
```

### Using Exports

```lua
exports['retro-kit']:RegisterContext(source, "export_menu", {
    title = "Export Menu",
    options = {
        action = {
            title = "Do Something",
            icon = "Zap",
            serverEvent = "myResource:action",
        },
    },
})

exports['retro-kit']:ShowContext(source, "export_menu")

-- Later, to force-close:
exports['retro-kit']:HideContext(source)
```

## Flow Diagram

```
Server                    Client (Lua)              NUI (React)
  │                           │                         │
  │  registerContext(...)     │                         │
  │  (stores menu data)      │                         │
  │                           │                         │
  │  showContext(player, id)  │                         │
  │── TriggerClientEvent ────>│                         │
  │   "retro-kit:showContext" │── SendNUIMessage ──────>│
  │                           │   "showContext"         │  (menu renders)
  │                           │                         │
  │                           │                         │  [Player clicks button]
  │                           │<── NUI Callback ────────│
  │                           │    "clickContext"       │  (menu hides)
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:contextClick"│                         │
  │                           │                         │
  │   [option has serverEvent]│                         │
  │── TriggerClientEvent ────>│                         │
  │   "retro-kit:context      │                         │
  │    ServerEvent"           │                         │
  │                           │── TriggerServerEvent ──>│
  │                           │   (e.g. "myRes:action") │
  │   handler receives with   │                         │
  │   correct `source`        │                         │
  │                           │                         │
  │       — SUBMENU —         │                         │
  │                           │                         │
  │                           │                         │  [Player clicks submenu]
  │                           │<── NUI Callback ────────│
  │                           │    "openContext"        │
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:contextOpen" │                         │
  │                           │                         │
  │  showContext(player, subId)                         │
  │── TriggerClientEvent ────>│                         │
  │   "retro-kit:showContext" │── SendNUIMessage ──────>│
  │                           │   "showContext"         │  (submenu renders)
  │                           │                         │
  │        — BACK —           │                         │
  │                           │                         │
  │                           │                         │  [Player clicks back]
  │                           │<── NUI Callback ────────│
  │                           │    "openContext"        │
  │                           │    { back: true }       │
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:contextBack" │                         │
  │                           │                         │
  │  showContext(player,      │                         │
  │    previousMenuId)        │                         │
  │── TriggerClientEvent ────>│                         │
  │   "retro-kit:showContext" │── SendNUIMessage ──────>│
  │                           │   "showContext"         │  (parent menu renders)
```

## Important Notes

- **Menus must be registered before showing.** Call `registerContext` before `showContext`.
- **`clickCallbacks` only work inside the `retro-kit` resource.** FiveM exports cannot transfer Lua functions between resources. Use `serverEvent` or `event` on options instead.
- **`serverEvent` preserves `source`.** The event is bounced through the client to ensure the handler receives the correct player `source`.
- **`event` triggers on the client.** Use this for client-side logic that doesn't need server validation.
- **Submenus use the `menu` property in two places:** on the submenu's data (to enable the back button) and on the parent's option (to navigate forward).
- **Options with `readOnly = true`** are displayed but clicking them does nothing.
- **Options with `disabled = true`** are greyed out and cannot be clicked.
