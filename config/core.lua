--- Core framework configuration. Keep server credentials in oxmysql's connection string.
Config.Core = {
    debug = false,
    developerMode = false,
    framework = 'qb-core',
    language = 'en',
    database = { resource = 'oxmysql', logRetentionDays = 30 },
    autosave = { enabled = true, intervalSeconds = 60 },
    resources = { oxmysql = 'oxmysql', oxlib = 'ox_lib', qbcore = 'qb-core' },
    keybinds = { open = Config.Keybind or 'F7' },
    cache = { ttlSeconds = 300, sweepSeconds = 60 },
    permissions = { defaultRole = 'user', acePrefix = 'cinedirector.' }
}
