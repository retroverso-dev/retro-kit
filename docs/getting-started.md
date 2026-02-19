# Getting Started

## Requirements

- FiveM server with `lua54` support
- `retro-kit` resource running before any dependent resource

## Installation

1. Place the `retro-kit` folder in your server's `resources` directory.
2. Add `ensure retro-kit` to your `server.cfg` **before** any resource that depends on it.

```cfg
ensure retro-kit
ensure my-resource
```

## Setting Up a Dependent Resource

In your resource's `fxmanifest.lua`:

```lua
fx_version 'cerulean'
game 'gta5'
lua54 'yes'

dependency 'retro-kit'

shared_scripts {
    '@retro-kit/init.lua',
}

server_scripts {
    'server/main.lua',
}

client_scripts {
    'client/main.lua',
}
```

The `init.lua` file will:

- Validate that `retro-kit` is started
- Prevent double initialization
- Load the `retro` global with all available functions

## Using Exports Directly

If you prefer not to use `init.lua`, you can call exports directly:

```lua
exports['retro-kit']:TriggerNotification(player, title, description, style, options)
exports['retro-kit']:TriggerAlert(player, title, description, options)
exports['retro-kit']:TriggerProgress(player, label, duration, options, onComplete)
exports['retro-kit']:TriggerCircleProgress(player, label, duration, options, onComplete)
exports['retro-kit']:CancelProgress(player)
exports['retro-kit']:RegisterContext(player, id, data)
exports['retro-kit']:ShowContext(player, id)
exports['retro-kit']:HideContext(player)
```

## Using the `retro` Global

After loading `init.lua`, the `retro` table is available globally:

```lua
retro.notify(player, data)
retro.alert(player, data)
retro.progress(player, data, onComplete)
retro.circleProgress(player, data, onComplete)
retro.cancelProgress(player)
retro.registerContext(player, id, data)
retro.showContext(player, id)
retro.hideContext(player)
```
