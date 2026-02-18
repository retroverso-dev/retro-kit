# Circle Progress

Display a circular progress indicator with optional label, percentage, and cancellation support.

## Server API

### Using `retro` global

```lua
retro.circleProgress(player, data, onComplete)
```

### Using exports

```lua
exports['retro-kit']:TriggerCircleProgress(player, label, duration, options, onComplete)
```

## Parameters

### `retro.circleProgress`

| Parameter    | Type       | Required | Default | Description                    |
| ------------ | ---------- | -------- | ------- | ------------------------------ |
| `player`     | `number`   | ✅       | —       | Server ID of the target player |
| `data`       | `table`    | ✅       | —       | Progress data (see below)      |
| `onComplete` | `function` | ❌       | `nil`   | Callback when progress ends    |

### `TriggerCircleProgress` Export

| Parameter    | Type       | Required | Default | Description                     |
| ------------ | ---------- | -------- | ------- | ------------------------------- |
| `player`     | `number`   | ✅       | —       | Server ID of the target player  |
| `label`      | `string`   | ✅       | —       | Text displayed below the circle |
| `duration`   | `number`   | ✅       | —       | Duration in milliseconds        |
| `options`    | `table`    | ❌       | `{}`    | Additional options (see below)  |
| `onComplete` | `function` | ❌       | `nil`   | Callback when progress ends     |

### Data / Options Properties

| Property    | Type      | Required | Default    | Description                                |
| ----------- | --------- | -------- | ---------- | ------------------------------------------ |
| `label`     | `string`  | ❌       | `""`       | Text displayed below the circle            |
| `duration`  | `number`  | ✅       | —          | Duration in milliseconds                   |
| `position`  | `string`  | ❌       | `"middle"` | `"top"`, `"middle"`, or `"bottom"`         |
| `percent`   | `boolean` | ❌       | `false`    | Show percentage inside the circle          |
| `canCancel` | `boolean` | ❌       | `false`    | Allow the player to cancel by pressing ESC |

### Callback

The `onComplete` callback receives a single boolean parameter:

```lua
function(cancelled)
    -- cancelled: true if cancelled by player or server
    -- cancelled: false if completed normally
end
```

## Cancellation

Circle progress uses the **same cancellation system** as the linear progress bar. See [Progress Bar > Cancellation](./progress-bar.md#cancellation) for details.

```lua
-- Server-side cancel
retro.cancelProgress(player)

-- or
exports['retro-kit']:CancelProgress(player)
```

> **Note:** `CancelProgress` cancels whichever progress is currently active (linear or circle).

## Examples

### Basic Circle Progress

```lua
retro.circleProgress(source, {
    label = "Processing...",
    duration = 5000,
}, function(cancelled)
    if cancelled then
        print("Cancelled!")
    else
        print("Done!")
    end
end)
```

### Circle with Percentage

```lua
retro.circleProgress(source, {
    label = "Hacking terminal...",
    duration = 12000,
    percent = true,
    position = "middle",
})
```

### Cancellable Circle Progress

```lua
retro.circleProgress(source, {
    label = "Lockpicking...",
    duration = 6000,
    percent = true,
    canCancel = true,
    position = "middle",
}, function(cancelled)
    if cancelled then
        retro.notify(source, {
            style = "error",
            title = "Failed",
            description = "You failed to pick the lock.",
            icon = "Lock",
        })
    else
        retro.notify(source, {
            style = "success",
            title = "Unlocked!",
            description = "The door is now open.",
            icon = "LockOpen",
            iconAnimation = "bounce",
        })
    end
end)
```

### Using Exports

```lua
exports['retro-kit']:TriggerCircleProgress(
    source,
    "Scanning area...",
    8000,
    {
        position = "middle",
        percent = true,
        canCancel = true,
    },
    function(cancelled)
        if not cancelled then
            -- Reveal items on map
        end
    end
)
```

### Combined with Notification Feedback

```lua
retro.notify(source, {
    style = "info",
    title = "Fishing",
    description = "You cast your line...",
    duration = 2000,
})

Citizen.SetTimeout(2000, function()
    retro.circleProgress(source, {
        label = "Waiting for a bite...",
        duration = 10000,
        percent = false,
        canCancel = true,
        position = "bottom",
    }, function(cancelled)
        if cancelled then
            retro.notify(source, {
                style = "warning",
                title = "Fishing",
                description = "You reeled in your line.",
            })
        else
            retro.notify(source, {
                style = "success",
                title = "Fishing",
                description = "You caught a fish!",
                icon = "Fish",
                iconAnimation = "bounce",
            })
        end
    end)
end)
```

## Visual Differences from Progress Bar

| Feature             | Progress Bar              | Circle Progress               |
| ------------------- | ------------------------- | ----------------------------- |
| Shape               | Horizontal bar            | Circular ring                 |
| Label position      | Above the bar             | Below the circle              |
| Percentage position | Right of the bar          | Center of the circle          |
| Best for            | Loading screens, crafting | Lockpicking, hacking, fishing |
| Container           | Card with header/footer   | Floating circle with backdrop |
