local C = CineDirector.Client
local function nui(name, fn) RegisterNUICallback(name, function(data, cb) local ok, result = pcall(fn, data or {}); cb({ ok = ok, result = result }) end) end
local function notify(message, kind) lib.notify({ title = 'CineDirector', description = message, type = kind or 'inform' }) end
function C.restore(data)
  C.Entities.clear(); C.weather=data.weather or CineDirector.DefaultWeather; C.applyWeather(C.weather); C.timeline=data.timeline or C.timeline
  for _, entry in ipairs(data.entities or {}) do C.Entities.spawn(entry.type, entry) end
end
function C.openUi()
  C.open=true; SetNuiFocus(true,true); SendNUIMessage({ action='open', project={ id=C.projectId,name=C.projectName }, entities=C.Entities.serialize(), weather=C.weather, presets=C.presets })
end
function C.closeUi() C.open=false; SetNuiFocus(false,false); SendNUIMessage({action='close'}) end
nui('close', function() C.closeUi() end)
nui('spawn', function(data) local r,e=C.Entities.spawn(data.type,data); if not r then error(e) end; return r end)
nui('delete', function(data) C.Entities.delete(data.id) end)
nui('clone', function(data) return C.Entities.clone(data.id) end)
nui('rename', function(data) local r=C.entities[data.id]; if r then r.name=CineDirector.Util.safeName(data.name,r.name) end end)
nui('animation', function(data) local r=C.entities[data.id]; if r then if data.stop then C.Animations.stop(r.handle) else C.Animations.play(r.handle,data.animation) end end end)
nui('previewAnimation', function(data) C.Animations.preview(data.animation) end)
nui('camera', function(data) if data.action=='toggle' then C.Camera.toggle() elseif data.action=='preset' then C.Camera.savePreset(data.name or 'Preset') end end)
nui('weather', function(data) C.applyWeather(data) end)
nui('undo', function() C.undo() end); nui('redo', function() C.redo() end)
nui('save', function(data) C.projectName=CineDirector.Util.safeName(data.name,C.projectName); TriggerServerEvent(CineDirector.Events.save, C.projectId, C.projectName, C.snapshot()) end)
nui('load', function(data) TriggerServerEvent(CineDirector.Events.load, data.id) end)
RegisterNetEvent('cinedirector:client:projectSaved', function(id) C.projectId=id; SendNUIMessage({ action='saved', id=id }) end)
RegisterNetEvent('cinedirector:client:projectLoaded', function(project) C.projectId=project.id; C.projectName=project.name; C.restore(project.payload); C.openUi() end)
RegisterNetEvent(CineDirector.Events.notify, notify)
RegisterCommand(Config.Command, function() C.openUi() end, false)
RegisterKeyMapping(Config.Command, 'Open CineDirector', 'keyboard', Config.Keybind)
CreateThread(function() while true do Wait(Config.AutosaveSeconds*1000); if C.projectId then TriggerServerEvent(CineDirector.Events.save,C.projectId,C.projectName,C.snapshot(),true) end end end)
