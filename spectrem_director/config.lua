Config = {
  debug = false, command = 'spectredirector', keybind = 'F7', language = 'en',
  resources = { mysql='oxmysql', lib='ox_lib', core='qb-core', appearance='illenium-appearance', weather='Renewed-Weathersync' },
  limits = { actors=20, props=75, vehicles=12, history=30 },
  autosaveSeconds = 90, cacheSeconds = 300,
  roles = { user=1, director=2, moderator=3, admin=4, owner=5 },
  animations = {
    { label='Cheer', category='Gestures', dict='amb@world_human_cheering@male_a', clip='base' },
    { label='Clipboard', category='Work', dict='amb@world_human_clipboard@male@base', clip='base' },
    { label='Lean', category='Ambient', dict='amb@world_human_leaning@male@wall@back@foot_up@base', clip='base' }
  }
}
