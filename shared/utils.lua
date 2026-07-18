CineDirector.Util = {}
function CineDirector.Util.clamp(value, low, high) return math.max(low, math.min(high, value)) end
function CineDirector.Util.vecToTable(v) return { x = v.x, y = v.y, z = v.z, w = v.w } end
function CineDirector.Util.tableToVec(t) return vector3(tonumber(t.x) or 0.0, tonumber(t.y) or 0.0, tonumber(t.z) or 0.0) end
function CineDirector.Util.safeName(name, fallback) return tostring(name or fallback):sub(1, 80) end
