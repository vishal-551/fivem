function SpectremDirector.playAnimation(ped,animation) RequestAnimDict(animation.dict);while not HasAnimDictLoaded(animation.dict) do Wait(0) end;TaskPlayAnim(ped,animation.dict,animation.clip,4,-4,animation.duration or -1,animation.loop and 1 or 0,0,false,false,false) end
function SpectremDirector.stopAnimation(ped) ClearPedTasks(ped) end
