fx_version "bodacious"
game "gta5"
lua54 "yes"

ui_page "web/index.html"
ui_page_preload "yes"

server_scripts{ 
    "@vrp/lib/utils.lua", -- Only for vRP franeworks
    "sv_markets.lua"
}

shared_scripts {
    'config.lua',
}

client_scripts {
    "cl_markets.lua"
}

files{
    "web/**/*",
    "web/*.*",
}

escrow_ignore {
    "config.lua",
    "cl_markets.lua",
    "sv_markets.lua",
    "web/**/*",
    "web/*.*",
}