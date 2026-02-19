# Configuration

retro-kit is configured through the `resource/shared/config.lua` file.

## Config File

```lua
-- resource/shared/config.lua
Config = {}

Config.debug = true

Config.notification = {
    defaultDuration = 5000,
    defaultPosition = "top-right",
}

Config.alert = {
    defaultSize = "md",
}

return Config
```

## Properties

### General

| Property       | Type      | Default | Description                                                       |
| -------------- | --------- | ------- | ----------------------------------------------------------------- |
| `Config.debug` | `boolean` | `false` | Enable debug mode (activates `/test` command and verbose logging) |

### Notification Defaults

| Property                              | Type     | Default       | Description                                   |
| ------------------------------------- | -------- | ------------- | --------------------------------------------- |
| `Config.notification.defaultDuration` | `number` | `5000`        | Default notification duration in milliseconds |
| `Config.notification.defaultPosition` | `string` | `"top-right"` | Default notification position                 |

### Alert Defaults

| Property                   | Type     | Default | Description                                        |
| -------------------------- | -------- | ------- | -------------------------------------------------- |
| `Config.alert.defaultSize` | `string` | `"md"`  | Default alert dialog size (`"sm"`, `"md"`, `"lg"`) |

## Debug Mode

When `Config.debug = true`:

- The `/test` command is registered on the server
- Server-side events print debug information to the console
- Useful for development and testing

### Debug Commands

```
/test notification [style]    — Test notification (success, error, info, warning, default)
/test alert                   — Test alert dialog
/test progress                — Test linear progress bar
/test progress circle         — Test circle progress bar
```

## Runtime Access

The config is available server-side through:

```lua
RetroKitServer.config.debug
RetroKitServer.config.notification.defaultDuration
RetroKitServer.config.notification.defaultPosition
RetroKitServer.config.alert.defaultSize
```
