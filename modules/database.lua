--- Parameterized oxmysql repository primitives with callback and await entry points.
CineDirector = CineDirector or {}
CineDirector.Database = { ready = false }
local Database = CineDirector.Database
local function checkTable(tableName) assert(type(tableName) == 'string' and tableName:match('^[%a_]+$'), 'Invalid table name') end
local function columns(values)
    local names, params = {}, {}
    for name, value in pairs(values or {}) do assert(name:match('^[%a_]+$'), 'Invalid column name'); names[#names + 1] = name; params[#params + 1] = value end
    assert(#names > 0, 'At least one value is required'); return names, params
end
local function where(filters, params)
    local predicates = {}
    for name, value in pairs(filters or {}) do assert(name:match('^[%a_]+$'), 'Invalid filter name'); predicates[#predicates + 1] = ('`%s` = ?'):format(name); params[#params + 1] = value end
    assert(#predicates > 0, 'At least one filter is required'); return table.concat(predicates, ' AND ')
end
--- Creates a row and returns its insert id. Callback is optional; without it this awaits oxmysql.
function Database.Create(tableName, values, callback)
    checkTable(tableName); local names, params = columns(values); local marks = {}; for i=1,#names do names[i]='`'..names[i]..'`'; marks[i]='?' end
    local query=('INSERT INTO `%s` (%s) VALUES (%s)'):format(tableName,table.concat(names,','),table.concat(marks,','))
    if callback then return MySQL.insert(query, params, callback) end
    return MySQL.insert.await(query, params)
end
--- Updates rows and returns affected count.
function Database.Update(tableName, values, filters, callback)
    checkTable(tableName); local names, params=columns(values); local sets={}; for _,name in ipairs(names) do sets[#sets+1]='`'..name..'` = ?' end
    local clause=where(filters,params); local query=('UPDATE `%s` SET %s WHERE %s'):format(tableName,table.concat(sets,','),clause)
    if callback then return MySQL.update(query,params,callback) end; return MySQL.update.await(query,params)
end
--- Deletes rows and returns affected count.
function Database.Delete(tableName, filters, callback)
    checkTable(tableName); local params={}; local query=('DELETE FROM `%s` WHERE %s'):format(tableName,where(filters,params))
    if callback then return MySQL.update(query,params,callback) end; return MySQL.update.await(query,params)
end
--- Finds one row or nil.
function Database.Find(tableName, filters, callback)
    checkTable(tableName); local params={}; local query=('SELECT * FROM `%s` WHERE %s LIMIT 1'):format(tableName,where(filters,params))
    if callback then return MySQL.single(query,params,callback) end; return MySQL.single.await(query,params)
end
--- Finds rows matching filters, or all rows when filters is nil.
function Database.FindAll(tableName, filters, callback)
    checkTable(tableName); local params={}; local query=('SELECT * FROM `%s`'):format(tableName)
    if filters then query=query..' WHERE '..where(filters,params) end
    if callback then return MySQL.query(query,params,callback) end; return MySQL.query.await(query,params)
end
--- Determines whether a row exists.
function Database.Exists(tableName, filters, callback)
    local function result(row) return row ~= nil end
    if callback then return Database.Find(tableName,filters,function(row) callback(result(row)) end) end
    return result(Database.Find(tableName,filters))
end
--- Runs a set of parameterized statements atomically.
function Database.Transaction(statements, callback)
    assert(type(statements)=='table' and #statements>0,'Transaction requires statements')
    if callback then return MySQL.transaction(statements,callback) end; return MySQL.transaction.await(statements)
end
