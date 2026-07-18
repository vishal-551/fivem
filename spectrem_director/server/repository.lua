local Repo={}
function Repo.identifier(source) local player=SpectremDirector.Features.core and exports['qb-core']:GetCoreObject().Functions.GetPlayer(source); return player and player.PlayerData.citizenid or ('license:'..(GetPlayerIdentifierByType(source,'license') or source)) end
function Repo.list(owner) return SpectremDirector.Database.all('spectrem_director_projects',{owner_identifier=owner}) end
function Repo.load(owner,id) return SpectremDirector.Database.find('spectrem_director_projects',{id=id,owner_identifier=owner}) end
function Repo.save(owner,id,name,payload) if id then return SpectremDirector.Database.update('spectrem_director_projects',{name=name,payload=json.encode(payload)},{id=id,owner_identifier=owner}) end; return SpectremDirector.Database.create('spectrem_director_projects',{owner_identifier=owner,name=name,payload=json.encode(payload)}) end
SpectremDirector.Repository=Repo
