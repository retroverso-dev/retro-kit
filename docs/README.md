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
- [Configuration](./configuration.md)

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

3. Use the `retro` global anywhere in your server scripts:

```lua
retro.notify(playerId, {
    style = "success",
    title = "Hello!",
    description = "retro-kit is working.",
})
```
