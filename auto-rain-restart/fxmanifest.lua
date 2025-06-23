fx_version 'cerulean'
game 'gta5'

author 'Auto Rain System'
description 'Automatically changes weather to rain before server restart'
version '1.0.0'

shared_scripts {
    'config.lua'
}

server_scripts {
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

lua54 'yes'