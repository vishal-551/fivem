# CineDirector

CineDirector is an original, server-owned cinematic scene direction resource for FiveM. It does not reproduce any proprietary resource. It uses public QB-Core, ox_lib, and oxmysql interfaces only.

## Installation

1. Copy `CineDirector` to your server resources directory and ensure its folder name is `CineDirector`.
2. Import `sql/001_cinedirector.sql` into the database configured for oxmysql.
3. Ensure dependencies before this resource:
   ```cfg
   ensure ox_lib
   ensure oxmysql
   ensure qb-core
   ensure CineDirector
   ```
4. Grant access (or set the appropriate QB/ACE bridge policy):
   ```cfg
   add_ace group.admin cinedirector.use allow
   add_ace group.admin cinedirector.admin allow
   ```
5. Use `/cinedirector` or the configured F7 mapping.

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for all phases, operations, extension points, and performance notes.
