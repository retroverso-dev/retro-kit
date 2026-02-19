# Text UI

Display a persistent text prompt on screen with optional keybind indicators.

## Server API

### Using `retro` global

```lua
retro.textUi(player, data)
retro.textUiHide(player)
```

### Using exports

```lua
exports['retro-kit']:TriggerTextUi(player, data)
exports['retro-kit']:HideTextUi(player)
```

## Parameters

### `retro.textUi`

| Parameter | Type     | Required | Default | Description                    |
| --------- | -------- | -------- | ------- | ------------------------------ |
| `player`  | `number` | ✅       | —       | Server ID of the target player |
| `data`    | `table`  | ✅       | —       | TextUI configuration           |

### `retro.textUiHide`

| Parameter | Type     | Required | Default | Description                    |
| --------- | -------- | -------- | ------- | ------------------------------ |
| `player`  | `number` | ✅       | —       | Server ID of the target player |

## Data Properties

| Property   | Type                 | Required | Default          | Description                             |
| ---------- | -------------------- | -------- | ---------------- | --------------------------------------- |
| `position` | `string`             | ❌       | `"right-center"` | Screen position (see below)             |
| `content`  | `table` or `table[]` | ✅       | —                | Single content object or array of items |

## Positions

| Value             | Description                     |
| ----------------- | ------------------------------- |
| `"right-center"`  | Right side, vertically centered |
| `"left-center"`   | Left side, vertically centered  |
| `"top-center"`    | Top, horizontally centered      |
| `"bottom-center"` | Bottom, horizontally centered   |

## Content Properties

| Property | Type     | Required | Default | Description                            |
| -------- | -------- | -------- | ------- | -------------------------------------- |
| `text`   | `string` | ❌       | `nil`   | Text to display                        |
| `uiKey`  | `string` | ❌       | `nil`   | Keybind to display (e.g. `"E"`, `"G"`) |

When `uiKey` is provided, a styled key badge is shown before the text.

## Examples

### Single Prompt

```lua
retro.textUi(source, {
    position = "right-center",
    content = { uiKey = "E", text = "Interact" },
})
```

### Multiple Prompts

```lua
retro.textUi(source, {
    position = "right-center",
    content = {
        { uiKey = "E", text = "Open Door" },
        { uiKey = "G", text = "Lock Door" },
        { text = "Hold to interact" },
    },
})
```

### Text Only (No Keybind)

```lua
retro.textUi(source, {
    position = "top-center",
    content = { text = "You are entering a restricted zone" },
})
```

### Different Positions

```lua
-- Left side
retro.textUi(source, {
    position = "left-center",
    content = { uiKey = "F", text = "Pick up item" },
})

-- Bottom center
retro.textUi(source, {
    position = "bottom-center",
    content = { uiKey = "H", text = "Honk horn" },
})
```

### Hiding the TextUI

```lua
retro.textUiHide(source)
```

### Using Exports

```lua
exports['retro-kit']:TriggerTextUi(source, {
    position = "right-center",
    content = { uiKey = "E", text = "Interact" },
})

-- Later, to hide:
exports['retro-kit']:HideTextUi(source)
```

## Important Notes

- **TextUI is persistent.** It stays on screen until you explicitly call `textUiHide`.
- **Calling `textUi` again replaces the current TextUI.** Only one TextUI is shown at a time.
- **TextUI does not capture focus.** The player can still move and interact normally while the TextUI is visible.
- **No NUI callbacks are needed.** TextUI is display-only — the player doesn't click on it.
