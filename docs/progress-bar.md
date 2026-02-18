# Progress Bar

Display a linear progress bar with optional label, percentage, and cancellation support.

## Server API

### Using `retro` global

```lua
retro.progress(player, data, onComplete)
```

### Using exports

```lua
exports['retro-kit']:TriggerProgress(player, label, duration, options, onComplete)
```

## Parameters

### `retro.progress`

| Parameter    | Type       | Required | Default | Description                    |
| ------------ | ---------- | -------- | ------- | ------------------------------ |
| `player`     | `number`   | ✅       | —       | Server ID of the target player |
| `data`       | `table`    | ✅       | —       | Progress data (see below)      |
| `onComplete` | `function` | ❌       | `nil`   | Callback when progress ends    |

### `TriggerProgress` Export

| Parameter    | Type       | Required | Default | Description                    |
| ------------ | ---------- | -------- | ------- | ------------------------------ |
| `player`     | `number`   | ✅       | —       | Server ID of the target player |
| `label`      | `string`   | ✅       | —       | Text displayed above the bar   |
| `duration`   | `number`   | ✅       | —       | Duration in milliseconds       |
| `options`    | `table`    | ❌       | `{}`    | Additional options (see below) |
| `onComplete` | `function` | ❌       | `nil`   | Callback when progress ends    |

### Data / Options Properties

| Property    | Type      | Required | Default    | Description                                |
| ----------- | --------- | -------- | ---------- | ------------------------------------------ |
| `label`     | `string`  | ❌       | `""`       | Text displayed above the progress bar      |
| `duration`  | `number`  | ✅       | —          | Duration in milliseconds                   |
| `position`  | `string`  | ❌       | `"middle"` | `"top"`, `"middle"`, or `"bottom"`         |
| `percent`   | `boolean` | ❌       | `false`    | Show percentage text next to the bar       |
| `canCancel` | `boolean` | ❌       | `false`    | Allow the player to cancel by pressing ESC |

### Callback

The `onComplete` callback receives a single boolean parameter:

```lua
function(cancelled)
    -- cancelled: true if the player or server cancelled the progress
    -- cancelled: false if the progress completed normally
end
```

## Cancellation

### Player Cancellation

When `canCancel = true`, the player can press **ESC** to cancel the progress. The Lua client handles the key detection and sends the cancel command to the NUI.

### Server-Side Cancellation

```lua
retro.cancelProgress(player)

-- or using exports:
exports['retro-kit']:CancelProgress(player)
```

## Examples

### Basic Progress Bar

```lua
retro.progress(source, {
    label = "Loading...",
    duration = 5000,
}, function(cancelled)
    if cancelled then
        print("Player cancelled!")
    else
        print("Progress completed!")
    end
end)
```

### Progress with Percentage

```lua
retro.progress(source, {
    label = "Downloading update...",
    duration = 10000,
    percent = true,
    position = "bottom",
})
```

### Cancellable Progress

```lua
retro.progress(source, {
    label = "Repairing vehicle...",
    duration = 8000,
    percent = true,
    canCancel = true,
    position = "bottom",
}, function(cancelled)
    if cancelled then
        retro.notify(source, {
            style = "warning",
            title = "Repair Cancelled",
            description = "You stopped repairing the vehicle.",
        })
    else
        retro.notify(source, {
            style = "success",
            title = "Repair Complete",
            description = "Vehicle has been fully repaired!",
        })
    end
end)
```

### Using Exports

```lua
exports['retro-kit']:TriggerProgress(
    source,
    "Crafting item...",
    6000,
    {
        position = "bottom",
        percent = true,
        canCancel = true,
    },
    function(cancelled)
        if not cancelled then
            -- Give item to player
        end
    end
)
```

### Server-Side Cancel

```lua
-- Start a progress
retro.progress(source, {
    label = "Waiting for backup...",
    duration = 30000,
    canCancel = false, -- player can't cancel, only server
}, function(cancelled)
    if cancelled then
        print("Server cancelled the wait")
    end
end)

-- Cancel it later from server
Citizen.SetTimeout(5000, function()
    retro.cancelProgress(source)
end)
```

## Flow Diagram

```
Server                    Client (Lua)              NUI (React)
  │                           │                         │
  │── TriggerClientEvent ────>│                         │
  │   "retro-kit:progress"    │── SendNUIMessage ──────>│
  │                           │   "progress"            │  (bar starts filling)
  │                           │                         │
  │                           │   [Player presses ESC]  │
  │                           │── SendNUIMessage ──────>│
  │                           │   "progressCancel"      │  (bar hides)
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:progressCancelled"                     │
  │                           │                         │
  │   onComplete(true)        │                         │
  │                           │                         │
  │          — OR —           │                         │
  │                           │                         │
  │                           │<── NUI Callback ────────│
  │                           │    "progressComplete"   │  (bar reached 100%)
  │<── TriggerServerEvent ────│                         │
  │   "retro-kit:progressComplete"                      │
  │                           │                         │
  │   onComplete(false)       │                         │
```
