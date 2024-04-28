fx_version 'bodacious'
games {'gta5'}
lua54 'yes'

description 'Trash searching script'
author 'Henk W'
version '1.2.7'

shared_scripts {
    'config.lua',
    '@es_extended/imports.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    'server/main.lua',
    '@mysql-async/lib/MySQL.lua'
}