--- Public client animation API and resource exports.
CineDirector.AnimationManager = {}
local Manager=CineDirector.AnimationManager
function Manager.PlayAnimation(ped, animation, options) return CineDirector.AnimationPreview.Play(ped,animation,options) end
function Manager.StopAnimation(ped) CineDirector.AnimationPreview.Stop(ped) end
function Manager.PreviewAnimation(animation, options) local ok,reason=Manager.PlayAnimation(PlayerPedId(),animation,options); if ok then local entry=CineDirector.AnimationLoader.Resolve(animation); if entry then CineDirector.AnimationCache.Release(entry.dictionary); TriggerServerEvent('cinedirector:animation:history',entry.dictionary,entry.clip) end end; return ok,reason end
function Manager.SearchAnimations(query, options) return CineDirector.AnimationSearch.Find(query,options) end
exports('PlayAnimation',Manager.PlayAnimation)
exports('StopAnimation',Manager.StopAnimation)
exports('PreviewAnimation',Manager.PreviewAnimation)
exports('SearchAnimations',Manager.SearchAnimations)
CreateThread(function() while true do Wait(30000);CineDirector.AnimationCache.Prune() end end)
AddEventHandler('onResourceStop',function(resource) if resource==GetCurrentResourceName() then Manager.StopAnimation(PlayerPedId());CineDirector.AnimationCache.Prune() end end)
