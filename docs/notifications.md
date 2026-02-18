# Notifications

Display toast notifications to players using the Sonner toast library.

## Server API

### Using `retro` global

```lua
retro.notify(player, data)
```

### Using exports

```lua
exports['retro-kit']:TriggerNotification(player, title, description, style, options)
```

### Using the generic UI export

```lua
exports['retro-kit']:UI(player, 'notify', data)
```

## Parameters

| Parameter | Type     | Required | Default | Description                    |
| --------- | -------- | -------- | ------- | ------------------------------ |
| `player`  | `number` | ✅       | —       | Server ID of the target player |
| `data`    | `table`  | ✅       | —       | Notification data (see below)  |

### Data Properties

| Property        | Type      | Required | Default       | Description                                                   |
| --------------- | --------- | -------- | ------------- | ------------------------------------------------------------- |
| `style`         | `string`  | ✅       | —             | `"success"`, `"error"`, `"info"`, `"warning"`, or `"default"` |
| `title`         | `string`  | ✅       | —             | Notification title                                            |
| `description`   | `string`  | ✅       | —             | Notification body text                                        |
| `duration`      | `number`  | ❌       | `5000`        | Duration in milliseconds                                      |
| `showDuration`  | `boolean` | ❌       | `false`       | Show a progress bar indicating remaining time                 |
| `icon`          | `string`  | ❌       | Style default | Lucide icon name (e.g., `"Bell"`, `"CircleCheck"`)            |
| `iconAnimation` | `string`  | ❌       | `"none"`      | `"spin"`, `"pulse"`, `"bounce"`, `"shake"`, or `"none"`       |
| `iconColor`     | `string`  | ❌       | Style color   | Custom icon color (hex, e.g., `"#ff00ff"`)                    |
| `position`      | `string`  | ❌       | `"top-right"` | Toast position on screen                                      |

### Available Positions

- `"top-left"`
- `"top-center"`
- `"top-right"`
- `"bottom-left"`
- `"bottom-center"`
- `"bottom-right"`

### Style Colors

| Style     | Default Color      |
| --------- | ------------------ |
| `success` | `#22c55e` (green)  |
| `error`   | `#ef4444` (red)    |
| `info`    | `#3b82f6` (blue)   |
| `default` | `#3b82f6` (blue)   |
| `warning` | `#eab308` (yellow) |

### Default Icons per Style

| Style     | Icon            |
| --------- | --------------- |
| `success` | `CircleCheck`   |
| `error`   | `OctagonX`      |
| `info`    | `Info`          |
| `default` | `Info`          |
| `warning` | `TriangleAlert` |

## Examples

### Basic Notification

```lua
retro.notify(source, {
    style = "success",
    title = "Saved!",
    description = "Your data has been saved successfully.",
})
```

### Notification with Duration Bar

```lua
retro.notify(source, {
    style = "info",
    title = "Processing",
    description = "Please wait while we process your request.",
    duration = 8000,
    showDuration = true,
})
```

### Custom Icon and Animation

```lua
retro.notify(source, {
    style = "warning",
    title = "Low Health",
    description = "Your health is below 20%!",
    icon = "HeartPulse",
    iconAnimation = "pulse",
    duration = 5000,
})
```

### Custom Icon Color

```lua
retro.notify(source, {
    style = "default",
    title = "New Message",
    description = "You have a new message from the server.",
    icon = "Mail",
    iconColor = "#a855f7",
    position = "bottom-right",
})
```

### Error Notification

```lua
retro.notify(source, {
    style = "error",
    title = "Transaction Failed",
    description = "You don't have enough money.",
    icon = "DollarSign",
    iconAnimation = "shake",
    duration = 4000,
})
```

### Using Exports

```lua
exports['retro-kit']:TriggerNotification(
    source,
    "Welcome!",
    "Welcome to the server.",
    "success",
    {
        duration = 5000,
        showDuration = true,
        icon = "PartyPopper",
        iconAnimation = "bounce",
        position = "top-center"
    }
)
```
