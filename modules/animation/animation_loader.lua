--- Resolves registry entries or explicit descriptors and acquires their dictionaries.
CineDirector.AnimationLoader = {}
function CineDirector.AnimationLoader.Resolve(animation)
    local entry=type(animation)=='string' and CineDirector.AnimationRegistry.Get(animation) or animation
    if type(entry)~='table' or type(entry.dictionary)~='string' or type(entry.clip)~='string' then return nil,'Invalid animation' end
    local loaded,reason=CineDirector.AnimationCache.Acquire(entry.dictionary);if not loaded then return nil,reason end
    return entry
end
