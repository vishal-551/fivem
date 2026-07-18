--- Original in-memory animation catalogue. Resources may extend it with Register().
CineDirector = CineDirector or {}
CineDirector.AnimationRegistry = { entries = {}, ordered = {} }
local Registry = CineDirector.AnimationRegistry

--- Registers a validated animation descriptor and returns its stable key.
---@param entry table { dictionary:string, clip:string, label:string, category?:string, tags?:string[], metadata?:table }
---@return string
function Registry.Register(entry)
    assert(type(entry) == 'table' and type(entry.dictionary) == 'string' and type(entry.clip) == 'string', 'Animation dictionary and clip are required')
    local key = entry.dictionary .. ':' .. entry.clip
    local normal = { key=key, dictionary=entry.dictionary, clip=entry.clip, label=entry.label or entry.clip, category=entry.category or 'uncategorized', tags=entry.tags or {}, metadata=entry.metadata or {} }
    if not Registry.entries[key] then Registry.ordered[#Registry.ordered + 1] = key end
    Registry.entries[key] = normal
    return key
end
function Registry.Get(key) return Registry.entries[key] end
function Registry.All() local out={}; for _,key in ipairs(Registry.ordered) do out[#out+1]=Registry.entries[key] end; return out end
for _, category in ipairs(Config.AnimationCategories or {}) do end
Registry.Register({dictionary='amb@world_human_cheering@male_a',clip='base',label='Cheer',category='gestures',tags={'celebrate','crowd'}})
Registry.Register({dictionary='amb@world_human_hang_out_street@male_b@idle_a',clip='idle_a',label='Street Idle',category='ambient',tags={'idle','street'}})
Registry.Register({dictionary='anim@mp_player_intcelebrationmale@dance',clip='dance',label='Dance',category='dance',tags={'dance','celebrate'}})
