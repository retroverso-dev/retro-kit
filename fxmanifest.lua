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
    'resource/shared/*.lua',
}

client_scripts {
    'resource/client/*.lua',
}

server_scripts {
    'resource/server/*.lua',
}

files {
    'init.lua',
    'web/dist/**/*',
}

ui_page 'web/dist/index.html'