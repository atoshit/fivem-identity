fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'

shared_script '@es_extended/imports.lua'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'cards.lua',
    'server.lua'
}

client_script 'client.lua'

export 'DeferralCards'