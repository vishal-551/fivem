CineDirector.Client = CineDirector.Client or {}
local C = CineDirector.Client
C.open, C.projectId, C.projectName = false, nil, 'Untitled Scene'
C.entities, C.history, C.future, C.presets = {}, {}, {}, {}
C.weather = CineDirector.DefaultWeather
function C.snapshot() return { entities = C.Entities and C.Entities.serialize() or {}, weather = C.weather, timeline = C.timeline or {} } end
function C.pushUndo() C.history[#C.history + 1] = json.encode(C.snapshot()); if #C.history > 25 then table.remove(C.history, 1) end; C.future = {} end
function C.undo() local item = table.remove(C.history); if item then C.future[#C.future + 1] = json.encode(C.snapshot()); C.restore(json.decode(item)) end end
function C.redo() local item = table.remove(C.future); if item then C.history[#C.history + 1] = json.encode(C.snapshot()); C.restore(json.decode(item)) end end
