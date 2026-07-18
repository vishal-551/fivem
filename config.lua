Config = {}
Config.Command = 'cinedirector'
Config.Keybind = 'F7'
Config.RequiredAce = 'cinedirector.use'
Config.AutosaveSeconds = 60
Config.MaxActors = 24
Config.MaxProps = 80
Config.MaxVehicles = 16
Config.DefaultFov = 55.0
Config.DefaultSpeed = 1.5
Config.GridSize = 0.25
Config.AppearanceResources = { 'illenium-appearance', 'qb-clothing', 'fivem-appearance' }
Config.Roles = { user = 1, moderator = 2, admin = 3 }
Config.RoleAces = { admin = 'cinedirector.admin', moderator = 'cinedirector.moderator' }
Config.AnimationCategories = {
  { id = 'gestures', label = 'Gestures' }, { id = 'cinematic', label = 'Cinematic' },
  { id = 'ambient', label = 'Ambient' }, { id = 'dance', label = 'Dance' }
}

-- Phase 3 animation framework defaults.
Config.Animation = {
  defaultSpeed = 1.0,
  defaultLoop = true,
  blendIn = 4.0,
  blendOut = -4.0,
  cacheSize = 24,
  unusedAssetSeconds = 90,
  favoriteLimit = 100,
  debug = false
}
