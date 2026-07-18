SpectremDirector.Rpc = { handlers={} }
function SpectremDirector.Rpc.register(name,handler) assert(not SpectremDirector.Rpc.handlers[name],'duplicate RPC'); SpectremDirector.Rpc.handlers[name]=handler end
SpectremDirector.EventBus.register(SpectremDirector.Events.request,function(id,name,payload)
  local source=source; local handler=SpectremDirector.Rpc.handlers[name]; if not handler then return TriggerClientEvent(SpectremDirector.Events.response,source,id,false,'Unknown request') end
  local ok,result=xpcall(function() return handler(source,payload) end,debug.traceback); if not ok then SpectremDirector.Log.error('RPC failed',{name=name,error=result}); result='Request failed' end
  TriggerClientEvent(SpectremDirector.Events.response,source,id,ok,result)
end,true)
