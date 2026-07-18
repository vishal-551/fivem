# Spectrem Director installation

1. Place the `spectrem_director` directory in your resources directory.
2. Import `database/001_spectrem_director.sql` into the database configured by oxmysql.
3. Add exactly `ensure spectrem_director` after the dependencies already listed in `server.cfg`.
4. Grant directors `add_ace group.admin spectrem_director.director allow` (or a higher role).
5. Use `/spectredirector` or F7.

The startup report detects all configured integrations. A missing optional appearance or weather resource only disables that capability. Database persistence is unavailable if oxmysql is missing; local direction tools remain available.

## Integration contract

Illenium appearance is used only through its public `setPedAppearance(ped, appearance)` export. Renewed-Weathersync is used only through its public `setWeather(weather)` export; client clock control remains local to avoid changing global weather for other players.
