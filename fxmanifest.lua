fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.1'
author 'Aleks'
description 'Aleks Fishing Script'

shared_scripts { 
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client.lua',
    'server.lua'
}

server_scripts { 
    'server.lua'
}

dependencies { 'ox_lib' }
