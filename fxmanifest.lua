
fx_version 'cerulean'

author 'MwR'

game 'gta5'

description 'Vehicle Rental Script'
version '2.1.0'

shared_script {
	'config.lua',
	'@ox_lib/init.lua',
	'@qb-core/shared/locale.lua',
    'locales/pt-br.lua',
    'locales/*.lua',
}

client_scripts {
	'client/*.lua',
}

server_scripts {
	'server/*.lua'
}

lua54 'yes'

escrow_ignore { 
    'client/*.lua',
    'server/server.lua',
    'config.lua',
    'locales/*.lua'
}
dependency '/assetpacks'