CineDirector.Repository = {}
local R = CineDirector.Repository
function R.saveProject(owner, id, name, payload)
  local encoded=json.encode(payload)
  if id then MySQL.update.await('UPDATE cinedirector_projects SET name=?, payload=?, updated_at=CURRENT_TIMESTAMP WHERE id=? AND owner_identifier=?',{name,encoded,id,owner}); return id end
  return MySQL.insert.await('INSERT INTO cinedirector_projects (owner_identifier,name,payload) VALUES (?,?,?)',{owner,name,encoded})
end
function R.loadProject(owner,id) return MySQL.single.await('SELECT id,name,payload FROM cinedirector_projects WHERE id=? AND owner_identifier=?',{id,owner}) end
function R.backup(id,payload) MySQL.insert.await('INSERT INTO cinedirector_backups (project_id,payload) VALUES (?,?)',{id,json.encode(payload)}) end
function R.settings(identifier, value) MySQL.prepare.await('INSERT INTO cinedirector_user_settings (identifier,settings) VALUES (?,?) ON DUPLICATE KEY UPDATE settings=VALUES(settings)',{identifier,json.encode(value)}) end
