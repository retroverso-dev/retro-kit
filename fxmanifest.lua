fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'retro-kit'
author 'retroverso.dev'
version '0.1.0'
description 'A collection of tools and resources for GTA V modding and development.'
repository 'https://github.com/retroverso-dev/retro-kit'
license 'LGPL-3.0-or-later + additional terms'

shared_scripts {
    'resource/shared/config.lua',
}

client_scripts {
    'resource/client/main.lua',
    'resource/client/ui/notify/events.lua',
    'resource/client/ui/alert/events.lua',
    'resource/client/ui/alert/callbacks.lua',
    'resource/client/ui/progress/events.lua',
    'resource/client/ui/progress/callbacks.lua',
    'resource/client/ui/context/events.lua',
    'resource/client/ui/context/callbacks.lua',
    'resource/client/ui/textui/events.lua',
}

server_scripts {
    'resource/server/bootstrap.lua',
    'resource/server/nui/events.lua',

    'resource/server/ui/notify/api.lua',
    'resource/server/ui/alert/api.lua',
    'resource/server/ui/alert/events.lua',
    'resource/server/ui/progress/api.lua',
    'resource/server/ui/progress/events.lua',
    'resource/server/ui/context/api.lua',
    'resource/server/ui/textui/api.lua',

    'resource/server/debug/commands.lua',
}

files {
    'init.lua',
    'imports/*.lua',
    'web/dist/**/*',
}

ui_page 'web/dist/index.html'