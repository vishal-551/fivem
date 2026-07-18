fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'CineDirector Contributors'
description 'Original collaborative cinematic scene direction toolkit for FiveM'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',
    'config/core.lua',
    'shared/config.lua',
    'modules/logger.lua',
    'modules/cache.lua',
    'modules/events.lua',
    'shared/constants.lua',
    'shared/utils.lua'
}

client_scripts {
    'modules/callbacks_client.lua',
    'modules/animation/animation_registry.lua',
    'modules/animation/animation_search.lua',
    'modules/animation/animation_cache.lua',
    'modules/animation/animation_loader.lua',
    'modules/animation/animation_preview.lua',
    'modules/animation/animation_favorites.lua',
    'modules/animation/animation_manager.lua',
    'client/state.lua',
    'client/animations.lua',
    'client/entities.lua',
    'client/camera.lua',
    'client/weather.lua',
    'client/timeline.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'modules/database.lua',
    'server/permissions.lua',
    'modules/permissions.lua',
    'modules/callbacks_server.lua',
    'server/resource_checker.lua',
    'server/animation/favorites.lua',
    'server/cache_scheduler.lua',
    'server/repository.lua',
    'server/main.lua'
}

ui_page 'html/index.html'
files { 'html/index.html', 'html/app.css', 'html/app.js' }

dependency { 'qb-core', 'ox_lib', 'oxmysql' }
