local function callback(name,handler) RegisterNUICallback(name,function(data,cb)local ok,result=pcall(handler,data or {});cb({ok=ok,result=result})end) end
local function send(action,data) data=data or {};data.action=action;SendNUIMessage(data) end
function SpectremDirector.open() SetNuiFocus(true,true);send('open',{project=SpectremDirector.Project,animations=Config.animations,entities=SpectremDirector.Entities.serialize()}) end
callback('close',function()SetNuiFocus(false,false);send('close')end)
callback('spawn',function(data)local record,error=SpectremDirector.Entities.spawn(data.type,data);assert(record,error);return record end)
callback('remove',function(data)SpectremDirector.Entities.remove(data.id)end)
callback('animation',function(data)if data.preview then return SpectremDirector.playAnimation(PlayerPedId(),data.animation) end;local e=SpectremDirector.Entities.records[data.id];if e then SpectremDirector.playAnimation(e.handle,data.animation) end end)
callback('camera',function()SpectremDirector.Camera.toggle()end)
callback('weather',function(data)SpectremDirector.Weather.apply(data)end)
callback('save',function(data)local ok,result=SpectremDirector.Rpc.await('project:save',{id=SpectremDirector.Project.id,name=data.name,payload=SpectremDirector.Project.snapshot()});if ok then SpectremDirector.Project.id=result;SpectremDirector.notify('Project saved','success')else error(result)end end)
callback('projects',function()return select(2,SpectremDirector.Rpc.await('project:list',{}))end)
callback('load',function(data)local ok,row=SpectremDirector.Rpc.await('project:load',{id=data.id});if not ok then error(row)end;SpectremDirector.Project.id=row.id;SpectremDirector.Project.name=row.name;SpectremDirector.Project.restore(row.payload);send('open',{project=SpectremDirector.Project,entities=SpectremDirector.Entities.serialize(),animations=Config.animations})end)
RegisterCommand(Config.command,SpectremDirector.open,false);RegisterKeyMapping(Config.command,'Open Spectrem Director','keyboard',Config.keybind)
CreateThread(function()while true do Wait(Config.autosaveSeconds*1000);if SpectremDirector.Project.id then SpectremDirector.Rpc.await('project:save',{id=SpectremDirector.Project.id,name=SpectremDirector.Project.name,payload=SpectremDirector.Project.snapshot()}) end;SpectremDirector.Cache.sweep() end end)
