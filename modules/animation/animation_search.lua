--- Allocation-light registry search with token scoring for instant NUI filtering.
CineDirector.AnimationSearch = {}
local function normalize(text) return tostring(text or ''):lower() end
local function score(entry, query)
    if query == '' then return 1 end
    local haystack = normalize(entry.label .. ' ' .. entry.dictionary .. ' ' .. entry.clip .. ' ' .. entry.category .. ' ' .. table.concat(entry.tags, ' '))
    if haystack:find(query, 1, true) then return 100 - (haystack:find(query, 1, true) or 0) end
    local position=1; for i=1,#query do position=haystack:find(query:sub(i,i),position,true); if not position then return 0 end; position=position+1 end
    return 10
end
--- Searches labels, dictionaries, categories, and tags. Options category/tags are optional.
function CineDirector.AnimationSearch.Find(query, options)
    options=options or {}; query=normalize(query); local result={}
    for _,entry in ipairs(CineDirector.AnimationRegistry.All()) do
        local match=score(entry,query)
        local category=not options.category or normalize(entry.category)==normalize(options.category)
        local tag=not options.tag or table.concat(entry.tags,' '):lower():find(normalize(options.tag),1,true)
        if match>0 and category and tag then result[#result+1]={entry=entry,score=match} end
    end
    table.sort(result,function(a,b) return a.score==b.score and a.entry.label<b.entry.label or a.score>b.score end)
    local output={};for _,item in ipairs(result) do output[#output+1]=item.entry end;return output
end
