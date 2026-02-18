# Alert Dialog

Display modal alert dialogs with optional confirm/cancel buttons and icons.

## Server API

### Using `retro` global

```lua
retro.alert(player, data)
```

### Using exports

```lua
exports['retro-kit']:TriggerAlert(player, title, description, options)
```

### Using the generic UI export

```lua
exports['retro-kit']:UI(player, 'alert', data)
```

## Parameters

| Parameter | Type     | Required | Default | Description                    |
| --------- | -------- | -------- | ------- | ------------------------------ |
| `player`  | `number` | ✅       | —       | Server ID of the target player |
| `data`    | `table`  | ✅       | —       | Alert data (see below)         |

### Data Properties

| Property         | Type      | Required | Default    | Description                                             |
| ---------------- | --------- | -------- | ---------- | ------------------------------------------------------- |
| `title`          | `string`  | ✅       | —          | Dialog title                                            |
| `description`    | `string`  | ✅       | —          | Dialog body text                                        |
| `size`           | `string`  | ❌       | `"md"`     | Dialog size: `"sm"`, `"md"`, or `"lg"`                  |
| `cancel`         | `boolean` | ❌       | `false`    | Show a cancel button                                    |
| `labels`         | `table`   | ❌       | See below  | Custom button labels                                    |
| `labels.cancel`  | `string`  | ❌       | `"Cancel"` | Cancel button text                                      |
| `labels.confirm` | `string`  | ❌       | `"OK"`     | Confirm button text                                     |
| `icon`           | `string`  | ❌       | `nil`      | Lucide icon name                                        |
| `iconAnimation`  | `string`  | ❌       | `"none"`   | `"spin"`, `"pulse"`, `"bounce"`, `"shake"`, or `"none"` |
| `iconColor`      | `string`  | ❌       | `nil`      | Icon color (Tailwind class, e.g., `"text-yellow-500"`)  |

## Server Events

When the player closes the alert, the server receives:

```lua
-- Event: retro-kit:closeAlert
-- Payload: { button = "confirm" } or { button = "cancel" }
```

## Examples

### Simple Alert (Confirm Only)

```lua
retro.alert(source, {
    title = "Welcome",
    description = "Welcome to the server! Please read the rules.",
    icon = "Info",
})
```

### Confirmation Dialog

```lua
retro.alert(source, {
    title = "Delete Character",
    description = "Are you sure you want to delete this character? This action cannot be undone.",
    cancel = true,
    icon = "Trash2",
    iconAnimation = "shake",
    iconColor = "text-red-500",
    labels = {
        cancel = "Keep it",
        confirm = "Delete"
    }
})
```

### Small Dialog

```lua
retro.alert(source, {
    title = "Quick Notice",
    description = "Server restart in 10 minutes.",
    size = "sm",
    icon = "Clock",
    iconAnimation = "spin",
})
```

### Large Dialog

```lua
retro.alert(source, {
    title = "Terms of Service",
    description = "By playing on this server you agree to follow all rules and guidelines set by the administration team. Breaking any rules may result in temporary or permanent ban.",
    size = "lg",
    cancel = true,
    icon = "FileText",
    labels = {
        cancel = "Decline",
        confirm = "I Agree"
    }
})
```

### Using Exports

```lua
exports['retro-kit']:TriggerAlert(
    source,
    "Confirm Purchase",
    "Do you want to buy this item for $500?",
    {
        cancel = true,
        icon = "ShoppingCart",
        iconAnimation = "bounce",
        labels = {
            cancel = "No",
            confirm = "Buy"
        }
    }
)
```

### Listening for Alert Response

```lua
-- On the server side, you can listen for when a player closes an alert:
AddEventHandler("retro-kit:closeAlert", function(payload)
    local player = source
    if payload.button == "confirm" then
        print(("Player %s confirmed the alert"):format(player))
    else
        print(("Player %s cancelled the alert"):format(player))
    end
end)
```
