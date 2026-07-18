fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Spectrem Director Contributors'
description 'Original local-first cinematic direction workspace'
version '2.0.0'
shared_scripts { 'config.lua', 'shared/constants.lua', 'shared/util.lua', 'modules/events.lua', 'modules/cache.lua' }
client_scripts { 'client/dependencies.lua', 'modules/notify.lua', 'modules/callback_client.lua', 'client/entities.lua', 'client/animation.lua', 'client/camera.lua', 'client/weather.lua', 'client/appearance.lua', 'client/projects.lua', 'client/favorites.lua', 'client/main.lua' }
server_scripts { 'server/dependencies.lua', 'modules/database.lua', 'modules/logger.lua', 'modules/permissions.lua', 'modules/callback_server.lua', 'server/repository.lua', 'server/main.lua' }
ui_page 'html/index.html'
files { 'html/index.html', 'html/app.css', 'html/app.js' }
