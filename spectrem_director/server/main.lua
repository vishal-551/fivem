local R=SpectremDirector.Repository
local function save(source,data) local owner=R.identifier(source);local name=SpectremDirector.Util.name(data.name,'Untitled');local id,reason=R.save(owner,tonumber(data.id),name,data.payload);if not id then SpectremDirector.Log.error('Project save failed',{source=source,error=reason});error('Storage unavailable')end;return tonumber(data.id) or id end
SpectremDirector.Rpc.register('project:save',function(source,data)if not SpectremDirector.Permissions.has(source,'director') then error('Director role required') end;assert(type(data.payload)=='table','Invalid project');return save(source,data)end)
SpectremDirector.Rpc.register('project:list',function(source)return R.list(R.identifier(source))end)
SpectremDirector.Rpc.register('project:load',function(source,data)local row=R.load(R.identifier(source),tonumber(data.id));if not row then error('Project not found')end;row.payload=json.decode(row.payload);return row end)
