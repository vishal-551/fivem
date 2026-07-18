local C = CineDirector.Client
C.Animations = {}
function C.Animations.load(dict) RequestAnimDict(dict); while not HasAnimDictLoaded(dict) do Wait(0) end end
function C.Animations.play(ped, animation)
  if not animation or not animation.dict or not animation.name then return end
  C.Animations.load(animation.dict)
  TaskPlayAnim(ped, animation.dict, animation.name, 4.0, -4.0, animation.duration or -1, animation.loop and 1 or 0, 0.0, false, false, false)
end
function C.Animations.stop(ped) ClearPedTasks(ped) end
function C.Animations.preview(animation) C.Animations.play(PlayerPedId(), animation) end
