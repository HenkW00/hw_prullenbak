fx_version 'bodacious'
games {'gta5'}

lua54 'yes'
version '1.2.5'

description 'Prullenbak script voor AMRP'
author 'Henk W'

shared_script 'config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'

escrow_ignore {
    'config.lua', 
    'fxmanifest.lua', 
}

server_scripts { '@mysql-async/lib/MySQL.lua' }

shared_script '@es_extended/imports.lua'
