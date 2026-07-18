local C = CineDirector.Client
C.timeline = { tracks = {}, duration = 30 }
function C.timelineAdd(track, at, action) C.timeline.tracks[#C.timeline.tracks+1] = { track=track, at=at, action=action } end
function C.playTimeline() CreateThread(function() local started=GetGameTimer(); for _,cue in ipairs(C.timeline.tracks) do while GetGameTimer()-started < cue.at*1000 do Wait(0) end; if cue.action.type=='animation' then local r=C.entities[cue.action.entity]; if r then C.Animations.play(r.handle,cue.action.animation) end end end end) end
