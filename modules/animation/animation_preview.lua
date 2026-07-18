--- Preview service tracks dictionary ownership per ped and avoids clearing unrelated tasks.
CineDirector.AnimationPreview = { active = {} }
local Preview=CineDirector.AnimationPreview
function Preview.Play(ped, animation, options)
    options=options or {};local entry,reason=CineDirector.AnimationLoader.Resolve(animation);if not entry then return false,reason end
    Preview.Stop(ped)
    local loop = options.loop; if loop == nil then loop = Config.Animation.defaultLoop end
    local flags=loop and 1 or 0
    TaskPlayAnim(ped,entry.dictionary,entry.clip,options.blendIn or Config.Animation.blendIn,options.blendOut or Config.Animation.blendOut,options.duration or -1,flags,options.speed or Config.Animation.defaultSpeed,false,false,false)
    Preview.active[ped]={ dictionary=entry.dictionary, clip=entry.clip };return true
end
function Preview.Stop(ped)
    local active=Preview.active[ped];if active then StopAnimTask(ped,active.dictionary,active.clip,Config.Animation.blendOut);CineDirector.AnimationCache.Release(active.dictionary);Preview.active[ped]=nil end
end
