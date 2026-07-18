SpectremDirector.Log = {}
function SpectremDirector.Log.write(level,message,context)
  if level=='DEBUG' and not Config.debug then return end
  print(('[spectrem_director][%s] %s'):format(level,message))
  if SpectremDirector.Database.available() then CreateThread(function() SpectremDirector.Database.create('spectrem_director_logs',{level=level,message=message,context=json.encode(context or {})}) end) end
end
for _,level in ipairs({'INFO','WARNING','ERROR','DEBUG'}) do SpectremDirector.Log[level:lower()]=function(message,context) SpectremDirector.Log.write(level,message,context) end end
