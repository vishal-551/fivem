--- Small TTL cache; data is evicted on read and by the low-frequency sweep.
SpectremDirector.Cache = { data = {} }
function SpectremDirector.Cache.set(group, key, value, seconds) SpectremDirector.Cache.data[group]=SpectremDirector.Cache.data[group] or {}; SpectremDirector.Cache.data[group][tostring(key)]={value=value, expires=GetGameTimer()+(seconds or Config.cacheSeconds)*1000} end
function SpectremDirector.Cache.get(group,key) local bucket=SpectremDirector.Cache.data[group] or {}; local item=bucket[tostring(key)]; if not item or item.expires<GetGameTimer() then bucket[tostring(key)]=nil; return nil end; return item.value end
function SpectremDirector.Cache.clear(group,key) if key then if SpectremDirector.Cache.data[group] then SpectremDirector.Cache.data[group][tostring(key)]=nil end else SpectremDirector.Cache.data[group]={} end end
function SpectremDirector.Cache.sweep() for group,bucket in pairs(SpectremDirector.Cache.data) do for key,item in pairs(bucket) do if item.expires<GetGameTimer() then bucket[key]=nil end end end end
