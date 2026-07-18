SpectremDirector.Util = {}
function SpectremDirector.Util.name(value, fallback) return tostring(value or fallback):gsub('[^%w%s%-%_]', ''):sub(1, 80) end
function SpectremDirector.Util.vector(value) return vector3(tonumber(value.x) or 0.0, tonumber(value.y) or 0.0, tonumber(value.z) or 0.0) end
function SpectremDirector.Util.table(vector) return { x=vector.x, y=vector.y, z=vector.z } end
function SpectremDirector.Util.copy(value) return json.decode(json.encode(value)) end
