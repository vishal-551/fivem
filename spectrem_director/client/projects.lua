SpectremDirector.Project={id=nil,name='Untitled',favorites={}}
function SpectremDirector.Project.snapshot() return {entities=SpectremDirector.Entities.serialize(),weather=SpectremDirector.Weather,camera=SpectremDirector.Camera.presets} end
function SpectremDirector.Project.restore(data) SpectremDirector.Entities.restore(data.entities);SpectremDirector.Weather.apply(data.weather or SpectremDirector.Weather);SpectremDirector.Camera.presets=data.camera or {} end
